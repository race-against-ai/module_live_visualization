import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    property var driverModel

    height: (leaderboardBackgroundDrivers.height * 0.80 ) / 20
    width: parent.width
    x: parent.width * 0.05

    Text {
        text: {
            try {
                if(driverModel.place > 9) {
                    return driverModel.place;
                } else {
                    return "0" + driverModel.place;
                }
            } catch(error) {
                return "";
            }
        }
        font.family: fontLoaderWide.name
        font.pointSize: {
            try {
                return parent.height * 0.4;
            } catch(error) {
                return 1;
            }
        }
        color: "white"
        Layout.leftMargin: 10
    }

    Text {
        text: leaderboardContainer.timeVisible ? driverModel.name.substring(0,3) : driverModel.name

        font.family: fontLoaderWide.name
        font.pointSize: {
            try {
                return parent.height * 0.4;
            } catch(error) {
                return 1;
            }
        }
        color: "white"
        x: parent.width * 0.2
    }

    Text {
        id: timeText
        text: {
            try {
                return driverModel.formatted_time;
            } catch(error) {
                return "";
            }
        }
        font.family: fontLoader.name
        font.pointSize: {
            try {
                return parent.height * 0.35;
            } catch(error) {
                return 1;
            }
        }
        color: "white"
        x: parent.width * 0.5
        opacity: leaderboardContainer.timeVisible ? 1 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: 500
            }
        }
    }

}
