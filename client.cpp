#include <QCoreApplication>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QWebSocket>
#include <QJsonDocument>
#include <QJsonObject>
#include <QUrl>
#include <QDebug>

#include "client.hpp"

Client::Client() {
    serverUrl = "http://192.168.76.219:3000/api/create-game";
    wsUrl = "ws://192.168.76.219:3000";
    host = false;
    strikes = 0;
}

void Client::start() {
    qDebug() << "Step 1: Creating game via HTTP POST...";

    QNetworkRequest request((QUrl(serverUrl)));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    // Send an empty JSON payload
    QByteArray jsonPayload = "{}";
    QNetworkReply* reply = networkManager.post(request, jsonPayload);

    // Connect the HTTP response signal to our parser slot
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        reply->deleteLater();
        if (reply->error() != QNetworkReply::NoError) {
            qCritical() << "HTTP POST Failed:" << reply->errorString();
            QCoreApplication::quit();
            return;
        }

        // Parse game credentials
        QJsonDocument doc = QJsonDocument::fromJson(reply->readAll());
        QJsonObject obj = doc.object();
        gameId = obj["gameId"].toString();
        hostToken = obj["hostToken"].toString();

        qDebug() << "Extracted Game ID:" << gameId;
        qDebug() << "Extracted Host Token:" << hostToken;

        // Move to Step 2
        connect_to_web_socket();
    });
}

void Client::connect_to_web_socket() {
    qDebug() << "Step 2: Connecting to WebSocket...";

    connect(&webSocket, &QWebSocket::connected, this, &Client::on_ws_connected);
    connect(&webSocket, &QWebSocket::textMessageReceived, this, &Client::on_message_recieved);

    webSocket.open(QUrl(wsUrl));
}

void Client::on_ws_connected() {
    qDebug() << "[WS Connection Established]";
    QJsonObject messageObj;
    if (host) {
        messageObj["action"] = "confirm";
        messageObj["message"] = "success";
        messageObj["token"] = hostToken;
        messageObj["gameId"] = gameId;
    } else {
        QJsonObject payload;

        messageObj["action"] = "guest_join";
        messageObj["payload"] = payload;
        messageObj["gameId"] = gameId;
        messageObj["token"] = "guest";

    }

    QJsonDocument doc(messageObj);
    QString wsPayload = doc.toJson(QJsonDocument::Compact);

    webSocket.sendTextMessage(wsPayload);
}

void Client::on_message_recieved(const QString& message) {
    qDebug() << "\n[WS Server Response]:" << message;

    if (!host) {
        QJsonParseError parseError;
        QJsonDocument doc = QJsonDocument::fromJson(message.toUtf8(), &parseError);

        if (parseError.error != QJsonParseError::NoError) {
            qWarning() << "Failed to parse incoming JSON:" << parseError.errorString();
            return;
        }

        QJsonObject jsonObj = doc.object();

        if (jsonObj.contains("error")) {
             qDebug() << "Error:" << jsonObj["error"].toString();
        } else if (jsonObj.contains("gameState") && !host) {
            QJsonObject gameState = jsonObj["gameState"].toObject();
            strikes = gameState["strikes"].toInt();
            balls = gameState["balls"].toInt();
            emit stateChanged();
        }
    }
}

void Client::update_info(int strikes, int balls, int inning, bool inning_half, int outs) {
    qDebug() << "Sending info to server...";

    QJsonObject payloadObj;
    payloadObj["strikes"] = strikes;
    payloadObj["balls"] = balls;
    payloadObj["inning"] = inning;
    payloadObj["inning_half"] = inning_half;
    payloadObj["outs"] = outs;

    QJsonObject messageObj;
    messageObj["action"] = "update_score";
    messageObj["token"] = hostToken;
    messageObj["gameId"] = gameId;
    messageObj["payload"] = payloadObj;

    QJsonDocument doc(messageObj);
    QString wsPayload = doc.toJson(QJsonDocument::Compact);

    webSocket.sendTextMessage(wsPayload);
}

int Client::get_strikes() { return strikes; }

void Client::set_strikes(int s) { strikes = s; }

void Client::set_gameId(QString GI) { gameId = GI; }

void Client::set_host(bool h) { host = h; }

bool Client::get_host() { return host; }

QString Client::get_gameId() { return gameId; }

int Client::getBalls() { return balls; }

void Client::setBalls(int b) { balls = b; }
