import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15


Item {
    property var driverModel

    id: timeItem
    height: (leaderboardBackgroundDrivers.height * 0.80 ) / 20
    width: parent.width
    x: parent.width * 0.55

    Text {
        text: {
            try {
                return driverModel.formatted_time;
            } catch(error) {
                return "";
            }
        }
        font.family: fontLoader.name
        font.pointSize: parent.height * 0.35
        color: "white"
        Layout.alignment: Qt.AlignHCenter
        Layout.fillWidth: true
        visible: !newTimeTimer.running
        Layout.leftMargin: 10
    }

    Timer {
        id: newTimeTimer
        running: false
        interval: 1500
        repeat: false
    }

    Connections {
        target: timeItem.driverModel
        function onTimeChanged(){
            newTimeTimer.start()
            console.log("Signal received")
        }
    }
}
