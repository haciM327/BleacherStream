#include <QCoreApplication>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QWebSocket>
#include <QJsonDocument>
#include <QJsonObject>
#include <QUrl>

#ifndef CLIENT_H
#define CLIENT_H

class Client : public QObject {
    Q_OBJECT

    Q_PROPERTY(int strikes READ get_strikes WRITE set_strikes NOTIFY stateChanged);
    Q_PROPERTY(int balls READ getBalls WRITE setBalls NOTIFY stateChanged FINAL)
    Q_PROPERTY(QString gameId READ get_gameId WRITE set_gameId)
    Q_PROPERTY(bool host READ get_host WRITE set_host);

    public:
        Client();

        Q_INVOKABLE void start();

        Q_INVOKABLE void update_info(int strikes, int balls, int inning, bool inning_half, int outs);

        int get_strikes();

        void set_strikes(int strikes);

        void set_gameId(QString GI);

        void set_host(bool h);

        bool get_host();

        int getBalls();

        void setBalls(int b);

        QString get_gameId();

        Q_INVOKABLE void connect_to_web_socket();

    private:


        void on_ws_connected();

        void on_message_recieved(const QString& message);

        QString serverUrl;
        QString wsUrl;
        QString gameId;
        QString hostToken;
        bool host;

        QNetworkAccessManager networkManager;
        QWebSocket webSocket;

        int strikes;
        int balls;
        int outs;
        bool inning_half;
        int inning;

    signals:
        void stateChanged();
};

#endif // CLIENT_H
