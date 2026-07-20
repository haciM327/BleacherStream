import QtQuick 6.2
import QtQuick.Controls 6.2
import QtQuick.Window 6.2

Rectangle {
    id: title
    signal switchPage(string page)
    color: "#0F1A2C"

    Text {
            id: label
            visible: true
            color: "#F8FAFC"
            text: qsTr("Welcome to Bleacher Stream!")
            anchors.top: title.top
            anchors.topMargin: 104
            font.pointSize: 32
            font.family: "Arial"
            anchors.horizontalCenterOffset: 0
            anchors.horizontalCenter: parent.horizontalCenter
    }
    Button {
        id: host
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenterOffset: -7
        anchors.horizontalCenterOffset: 0
        width: 132
        height: 52
        Text {
            id: hostText
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pointSize: 9
            color: "#F8FAFC"
            text: "Host a Game"
        }
        background: Rectangle {
            implicitWidth: 100
            implicitHeight: 40
            color: "#10B981"
            border.color: "#000000"
            border.width: 1
            radius: 6
        }

        onClicked: {
            client.host = true;
            switchPage("host.qml");
            client.start()
        }
    }
    Button {
        id: guest
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenterOffset: -107
        anchors.horizontalCenterOffset: 0
        width: 132
        height: 52
        Text {
            id: guestText
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pointSize: 9
            color: "#F8FAFC"
            text: "Join a Game"
        }
        background: Rectangle {
            implicitWidth: 100
            implicitHeight: 40
            color: "#10B981"
            border.color: "#000000"
            border.width: 1
            radius: 6
        }

        onClicked: {
            client.host = false;
            switchPage("guest.qml");
        }
    }
}