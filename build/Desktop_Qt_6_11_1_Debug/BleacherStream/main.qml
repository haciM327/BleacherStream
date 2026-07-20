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
    property bool host: false
    property string currentQmlFile: "title.qml"

    function switchToPage(page) {
            currentQmlFile = page;
            loader.source = page;
        }

    Loader {
            id: loader
            source: window.currentQmlFile
            anchors.fill: parent
        }

    Connections {
        target: loader.item
        function onSwitchPage(page) {
            switchToPage(page);
        }
    }

}