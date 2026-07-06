import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic


ApplicationWindow {
    id: window
    width: 640
    height: 480
    minimumWidth: 200
    minimumHeight: 250
    visible: true
    title: qsTr("Bleacher Stream")
    property bool lightMode: Application.styleHints.colorScheme === Qt.Light
    property color reallyDark: "#1f1f1f"
    property color dark: "#262626"
    property color reallyLight: "#e7e7e7"
    property color light: "#e0e0e0"

    Button {
        id: strike
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: -150
        anchors.verticalCenterOffset: 50
        width: 100
        height: 30
        text: "Strike"
        onClicked: {
            count.strikes += 1
            if (count.strikes == 3) {
                count.balls = 0
                count.strikes = 0
                out.outs += 1
                if (out.outs == 3) {
                    out.outs = 0
                    inning.inning_side = !inning.inning_side
                    if (inning.inning_side) {
                        inning.inning_num += 1
                    }
                }
            }
            count.text = count.balls + "-" + count.strikes
        }
    }
    Button {
        id: ball
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: 150
        anchors.verticalCenterOffset: 50
        width: 100
        height: 30
        text: "Ball"
        onClicked: {
            count.balls += 1
            if (count.balls == 4) {
                count.balls = 0
                count.strikes = 0
            }
            count.text = count.balls + "-" + count.strikes
        }
    }
    Text {
        id: count
        property int strikes: 0
        property int balls: 0
        text: count.balls + "-" + count.strikes
        color: "#FFFFFF"
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -50

    }
    Text {
        id: out
        property int outs: 0
        text: "Outs: " + out.outs
        anchors.centerIn: count
        anchors.verticalCenterOffset: -25
        color: "#FFFFFF"

    }
    Text {
        id: inning
        property bool inning_side: true
        property int inning_num: 1
        text: inning.inning_side ? "Top of the " + inning.inning_num : "Bottom of the " + inning.inning_num
        color: "#FFFFFF"
        anchors.centerIn: count
        anchors.verticalCenterOffset: -50
    }


}