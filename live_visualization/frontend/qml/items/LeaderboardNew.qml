import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
	id: leaderboardContainer
	anchors.fill: parent
    property bool timeVisible: true
    property bool absoluteDeltaTime: true

    signal requestNewLeaderboardSignal

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

		anchors.left: leaderboardBackgroundDrivers.left
		anchors.right: leaderboardBackgroundDrivers.right
		y: parent.height * 0.15

		anchors.horizontalCenter: leaderboardBackgroundTimes.horizontalCenter
    }

	onHeightChanged: {
        leaderboardContent.arrangeElements(false)
    }

    CostumButton {
        anchors.left: leaderboardContent.left
        text: {
            if(!absoluteDeltaTime) {
                return "Display delta times"
            } else {
                return "Display abs. times"
            }
        }

        anchors.bottom: parent.bottom
        height: parent.height * 0.05
        width: leaderboardContent.width
        onClicked: {
            if(absoluteDeltaTime) {
                absoluteDeltaTime = false;
            } else {
                absoluteDeltaTime = true;
            }
        }
    }

    CostumButton {
        id: requestLeaderboardButton
        objectName: "requestLeaderboardButton"
        anchors.left: leaderboardContent.right
        text: "Update Leaderboard"
        height: parent.height * 0.05
        width: leaderboardContent.width / 2
        onClicked: {
            console.log("Request button presses!")
            leaderboardContainer.requestNewLeaderboardSignal
        }
    }

	Connections {
		target: leaderboard_model

        onNewDriverAdded: {

            console.log("New driver added: " + newDriverModel.name);
            var comp = Qt.createComponent("DriverNew.qml");
            var elem = comp.createObject(leaderboardContent, {
                width: Qt.binding(function() { return leaderboardContent.width }),
                height: Qt.binding(function() { return (leaderboardBackgroundDrivers.height * 0.85) / 20 }),
                position: newDriverModel.position,
                driverModel: newDriverModel
            })
            leaderboardContent.elementList.push(elem)

		}

		onLeaderboardUpdated: {
			leaderboardContent.sortElements()
			leaderboardContent.arrangeElements()
		}
	}

    Connections {
        target: window

        onIsFullScreenChanged: {
            leaderboardContent.arrangeElements()
        }
    }

}
