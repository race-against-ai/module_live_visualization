import QtQuick 2.0

AnimatedColumnElement {

	id: animatedColumnElement

	property var driverModel
    property bool driverInfoVisible: false

    MouseArea {
        id: driverInfoArea
        anchors.fill: parent
        onClicked: {
            console.log(driverModel.name + "Object clicked!");
            if(driverInfoVisible === false) {
                parent.height = window.height * 0.2;
                driverInfoVisible = true;
            } else {
                parent.height = Qt.binding(function() { return (leaderboardBackgroundDrivers.height * 0.85) / 20 });
                driverInfoVisible = false;
            }
        }
    }

    Rectangle {
        id: driverInfoBackground
        anchors.fill: parent
        color: "black"
    }

	Text {
		id: positionText
		text: driverModel.position + 1
        font.pointSize: window.height * 0.015
		x: parent.width * 0.05
		color: "white"
		font.family: fontLoaderWide.name
		verticalAlignment: Qt.AlignVCenter
	}

	Text {
		id: nameText
        text: driverInfoVisible ? driverModel.name : driverModel.name.substring(0,3)
		x: parent.width * 0.2
        font.pointSize: window.height * 0.015
		font.family: fontLoaderWide.name
		verticalAlignment: Qt.AlignVCenter
		color: "white"
	}

	Text {
		id: timeText
		text: driverModel.time
        visible: !driverInfoVisible
        font.pointSize: window.height * 0.015
		font.family: fontLoaderWide.name
		x: parent.width / 2
		color: {
			if (colorTimer.running){
				if(driverModel.position === 0) {
					return "purple";
				}
				else {
					return "green";
				}
			} else {
				return "white";
			}
		}
	}

	Svg {
		id: improvementSymbol
		source: "./../../images/svg/improvement_symbol.svg"
        height: window.height * 0.01
		fillMode: Image.PreserveAspectFit
		x: parent.width * 0.05
		anchors.bottom: positionText.top
		opacity: improvementTimer.running ? 1 : 0

		Behavior on opacity {
			NumberAnimation {
				duration: 125
			}
		}
	}

	Svg {
		id: declineSymbol
		source: "./../../images/svg/decline_symbol.svg"
        height: window.height * 0.01
		fillMode: Image.PreserveAspectFit
		x: parent.width * 0.05
		anchors.top: positionText.bottom
		opacity: declineTimer.running ? 1 : 0

		Behavior on opacity {
			NumberAnimation {
				duration: 125
			}
		}
	}

//    Text {
//        anchors.left: numberText.right
//        font.pixelSize: 40
//        text: driverModel.place
//        color: "white"
//    }

	Timer {
		id: colorTimer
		running: false
		interval: 1500
		repeat: false
	}

	Timer {
		id: declineTimer
		running: false
		interval: 1500
		repeat: false
	}

	Timer {
		id: improvementTimer
		running: false
		interval: 1500
		repeat: false
	}

	onMovingUpChanged: {
		if (movingUp) {
			improvementTimer.start()
		}
	}

	onMovingDownChanged: {
		if (movingDown) {
			declineTimer.start()
		}
	}

	Connections {
		target: driverModel

		onPositionChanged: {
			animatedColumnElement.position = driverModel.position
		}

		onTimeChanged: {
			colorTimer.start()
		}
	}

}
