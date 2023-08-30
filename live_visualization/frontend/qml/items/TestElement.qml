import QtQuick 2.0

AnimatedColumnElement {

    id: animatedColumnElement


    property color inactiveColor: "#562723"
    property color activeColor: "red"

    property var driverModel


    Text {
        id: positionText
        text: {
            try {
                return driverModel.place;
            }
            catch(error) {
                return "";
            }
        }
        font.pointSize: parent.height * 0.4
        x: parent.width * 0.05
        color: "white"
        font.family: fontLoaderWide.name
        verticalAlignment: Qt.AlignVCenter
    }

    Text {
        id: nameText
        text: {
            try {
                return driverModel.name.substring(0,3);
            }
            catch(error) {
                return "";
            }
        }
        x: parent.width * 0.2
        font.pointSize: parent.height * 0.4
        font.family: fontLoaderWide.name
        verticalAlignment: Qt.AlignVCenter
        color: "white"
    }

    Text {
        id: timeText
        text: {
            try {
                return driverModel.time;
            }
            catch(error) {
                return "";
            }
        }
        font.pointSize: parent.height * 0.35
        font.family: fontLoaderWide.name
        x: parent.width / 2
        color: {
            if(colorTimer.running){
                if(driverModel.place === 1) {
                    return "purple";
                }
                else {
                    return "green";
                }
            }
            else {
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

    MouseArea {
        anchors.fill: parent
        onClicked: parent.clicked()
    }

    function update_position() {
		console.log(driverModel.place)
		moveToPosition(driverModel.place - 1)
        if((driverModel.place - 1)!== position) {
            if((driverModel.place - 1) < position) {

                improvementTimer.start()
            }
            else {
                declineTimer.start()
            }
        }
        else {
            declineTimer.start()
        }
    }

    function start_color_timer() {
        colorTimer.start()
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

    onDriverModelChanged: {
        driverModel.place_changed.connect(update_position)
        driverModel.time_changed.connect(start_color_timer)
    }

}
