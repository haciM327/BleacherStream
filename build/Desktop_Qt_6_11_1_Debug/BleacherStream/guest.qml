import QtQuick 6.2
import QtQuick.Controls 6.2
import QtQuick.Window 6.2

Rectangle {
    id: guest
    color: "#0F1A2C"
    signal switchPage(string page)

    Rectangle {
            id: gameIdRect
            visible: true
            width: 165
            height: 25
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 10
            border.color: "#e91e63"
            border.width: 1
            color: "black"
            TextArea {
                id: gameId
                width: 160
                anchors.centerIn: parent
                font.pointSize: 10
                visible: true
                color: "#e91e63"
                placeholderTextColor: "#e91e63"
                placeholderText: "Enter GameId"
                selectByMouse: true
            }
        }
    Button {
            id: go
            width: 132
            height: 52
            x: 40
            y: 40
            text: "Continue"
            visible: true
            background: Rectangle {
                implicitWidth: 100
                implicitHeight: 40
                color: "#e91e63"
                border.color: "#000000"
                border.width: 1
                radius: 6
            }
            onClicked: {
                client.gameId = gameId.text;
                console.log(client.gameId);
                client.connect_to_web_socket();
                out.visible = true;
                count.visible = true;
                inning.visible = true;
                go.visible = false;
                gameIdRect.visible = false;
                count.text = count.balls + "-" + client.strikes;


            }
        }
    Text {
        id: count
        property int strikes: 0
        property int balls: 0
        text: count.balls + "-0"
        color: "#FFFFFF"
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -50
        visible: false

    }
    Text {
        id: out
        property int outs: 0
        text: "Outs: " + out.outs
        anchors.centerIn: count
        anchors.verticalCenterOffset: -25
        color: "#FFFFFF"
        visible: false

    }
    Text {
        id: inning
        property bool inning_side: true
        property int inning_num: 1
        text: inning.inning_side ? "Top of the " + inning.inning_num : "Bottom of the " + inning.inning_num
        color: "#FFFFFF"
        anchors.centerIn: count
        anchors.verticalCenterOffset: -50
        visible: false
    }


    function update_count() {
        count.text = client.balls + "-" + client.strikes;
    }

    Connections {
        target: client
        function onStateChanged() {
            update_count();
        }
    }


}
