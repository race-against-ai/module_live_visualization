import QtQuick 2.15

AnimatedColumnElement {

    id: animatedColumnElement
        property var driverModel
        property bool driverInfoVisible: false
        property int originalHeight: (leaderboardBackgroundDrivers.height * 0.85) / 20

    MouseArea {
        anchors.fill: parent

        onClicked: {
             if(!driverInfoVisible) {
                 driverInfoVisible = true;
                 animatedColumnElement.height = window.height * 0.15;
                 leaderboardContent.arrangeElements();
             } else {
                 driverInfoVisible = false;
                 animatedColumnElement. height = originalHeight;
                 leaderboardContent.arrangeElements();
             }
        }
    }

    Rectangle {
        id: driverInfoBackground
        anchors.fill: parent
        opacity: driverInfoVisible ? 1 : 0
        radius: 5
        border.color: "black"
        border.width: 2

        gradient: Gradient {
            GradientStop { position: 0.0; color: "#010101" }
            GradientStop { position: 0.1; color: "#1D1D1D" }
            GradientStop { position: 1.0; color: "#2A2A2A" }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 500
            }
        }
    }

    Rectangle {
        id: bestTimeBackground
        height: parent.height * 0.75
        width: 0
        radius: 5
        opacity: 0.8

        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: "#792088" }
            GradientStop { position: 1.0; color: "#9444A2" }
        }

        SequentialAnimation {
            id: widthAnimation

            NumberAnimation {
                target: bestTimeBackground
                to: parent.width
                property: "width"
                duration: 500
                running: false
            }


            PauseAnimation {
                duration: 1000
            }

            ParallelAnimation {

                NumberAnimation {
                    target: bestTimeBackground
                    to: parent.width
                    property: "x"
                    duration: 250
                    running: false
                }

                NumberAnimation {
                    target: bestTimeBackground
                    to: 0
                    property: "width"
                    duration: 250
                    running: false
                }
            }

            NumberAnimation {
                target: bestTimeBackground
                to: 0
                property: "x"
                duration: 100
                running: false
            }
        }
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
        text: driverInfoVisible ? driverModel.name.substring(0,15) : driverModel.name.substring(0,3)
		x: parent.width * 0.2
        font.pointSize: window.height * 0.015
		font.family: fontLoaderWide.name
		verticalAlignment: Qt.AlignVCenter
		color: "white"
	}

	Text {
		id: timeText
        text: {
            if(leaderboardContainer.absoluteDeltaTime) {
                if(driverModel.position === 0) {
                    return driverModel.formatted_time;
                } else {
                    return "+" + driverModel.gap_to_first;
                }
            } else {
                return driverModel.formatted_time;
            }
        }

        opacity: driverInfoVisible ? 0 : 1
        font.pointSize: window.height * 0.0125
		font.family: fontLoaderWide.name
		x: parent.width / 2
        verticalAlignment: Qt.AlignVCenter
		color: {
			if (colorTimer.running){
				if(driverModel.position === 0) {
                    widthAnimation.start();
                    return "white";
				}
				else {
					return "green";
				}
			} else {
				return "white";
			}
		}

        Behavior on opacity {
            NumberAnimation {
                duration: 250
            }
        }
	}

    Text {
        id: bigTimeText
        text: driverModel.formatted_time
        font.pointSize: window.height * 0.02
        font.family: fontLoaderWide.name
        anchors.top: timeText.bottom
        opacity: driverInfoVisible ? 1 : 0
        x: parent.width * 0.2
        color: "white"
        y: parent.height * 0.2

        Behavior on opacity {
            NumberAnimation {
                duration: 250
            }
        }
    }

    Text {
        id: avgSpeed
        text: "Avg. Speed 3 m/s"
        font.pointSize: window.height * 0.0125
        font.family: fontLoaderWide.name
        anchors.top: bigTimeText.bottom
        opacity: driverInfoVisible ? 1 : 0
        x: parent.width * 0.2
        color: "#6b6b6b"
        y: parent.height * 0.1

        Behavior on opacity {
            NumberAnimation {
                duration: 250
            }
        }
    }

    Text {
        id: sessionTime
        text: "Session Time 1"
        font.pointSize: window.height * 0.0125
        font.family: fontLoaderWide.name
        anchors.top: avgSpeed.bottom
        opacity: driverInfoVisible ? 1 : 0
        x: parent.width * 0.2
        color: "#6b6b6b"

        Behavior on opacity {
            NumberAnimation {
                duration: 250
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
            animatedColumnElement.position = driverModel.position;
		}

		onTimeChanged: {
			colorTimer.start()
        }
    }

}
