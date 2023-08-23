import QtQuick 2.0

AnimatedColumnElement {

    id: animatedColumnElement


    property color inactiveColor: "#562723"
    property color activeColor: "red"

    property var driverModel

    Rectangle {
        id: backgroundRectangle

        color: movingUp ? activeColor : inactiveColor
        anchors.fill: parent

        radius: 10
    }


    Text {
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
        color: "white"
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

    function clicked() {
        moveToPosition(0)
    }

    function foo() {
        if((driverModel.place - 1)!== position) {
            if((driverModel.place - 1) < position) {
                moveToPosition(driverModel.place - 1)
            }
        }
    }

    onDriverModelChanged: {
        driverModel.place_changed.connect(foo)
    }

//    Connections {
//        target: driverModel
//        onplace_changed: {
//            moveToPosition(driverModel.place)
//        }
//    }

}
