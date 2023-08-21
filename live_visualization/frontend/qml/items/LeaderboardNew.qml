import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: leaderboardContainer
    anchors.fill: parent
    property bool timeVisible: true

    MouseArea {
        anchors.fill: leaderboardContent
        onClicked: {
            if(leaderboardContainer.timeVisible === false) {
                widthAnimation.to = 0;
                leaderboardContainer.timeVisible = true;
            } else {
                widthAnimation.to = window.height * 0.21;
                leaderboardContainer.timeVisible = false;
            }
            widthAnimation.start();
        }
    }

    Svg {
        id: leaderboardBackgroundTimes
        source: "./../../images/svg/test_image_0_times.svg"
        visible: true
        x: parent.height * 0.01
        y: parent.height / 2 - height / 2
        fillMode: Image.PreserveAspectFit
        height: parent.height * 0.9
    }

    Svg {
        id: leaderboardBackgroundDrivers
        source: "./../../images/svg/test_image_0_names.svg"
        visible: true
        x: parent.height * 0.01
        y: parent.height / 2 - height / 2
        fillMode: Image.PreserveAspectFit
        height: parent.height * 0.9
    }

    Rectangle {
        id: fullNameRectangle
        color: "black"
        x: parent.height * 0.05
        y: parent.height / 2 - height / 2
        height: parent.height * 0.9
        width: 0
    }

    Svg {
        id: leaderboardHeader
        source: "./../../images/svg/test_image_0_header.svg"
        visible: true
        y: parent.height / 2 - height / 2
        x: parent.height * 0.01
        fillMode: Image.PreserveAspectFit
        height: parent.height * 0.9
    }

    Svg {
        id: leaderboardBackgroundBorder
        source: "./../../images/svg/test_image_0_border.svg"
        visible: true
        x: parent.height * 0.01
        y: parent.height / 2 - height / 2
        fillMode: Image.PreserveAspectFit
        height: parent.height * 0.9
    }

    AnimatedColumn {
        id: leaderboardContent

        width: leaderboardBackgroundTimes.width
        y: 10

        anchors.horizontalCenter: leaderboardBackgroundTimes.horizontalCenter
    }

    PropertyAnimation {
        id: widthAnimation
        target: fullNameRectangle
        property: "width"
        duration: 500
    }


    Connections {
        target: leaderboard_model

        onNew_driver_added: {
            var comp = Qt.createComponent("TestElement.qml")

            var elem = comp.createObject(leaderboardContent, {
                    text: leaderboard_model.new_driver.name,
                    width: 100,
                    height: 50,
                    driverModel: leaderboard_model.new_driver
            })
            leaderboardContent.elementList.push(elem)
            leaderboardContent.rearrangeElements()
        }
    }
}
