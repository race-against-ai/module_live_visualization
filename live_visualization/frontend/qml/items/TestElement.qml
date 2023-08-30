import QtQuick 2.0

AnimatedColumnElement {

	id: animatedColumnElement

	property var driverModel


	Text {
		id: positionText
		text: driverModel.position + 1
		font.pointSize: parent.height * 0.4
		x: parent.width * 0.05
		color: "white"
		font.family: fontLoaderWide.name
		verticalAlignment: Qt.AlignVCenter
	}

	Text {
		id: nameText
		text: driverModel.name.substring(0,3)
		x: parent.width * 0.2
		font.pointSize: parent.height * 0.4
		font.family: fontLoaderWide.name
		verticalAlignment: Qt.AlignVCenter
		color: "white"
	}

	Text {
		id: timeText
		text: driverModel.time
		font.pointSize: parent.height * 0.35
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
		height: parent.height * 0.25
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
		height: parent.height * 0.25
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
