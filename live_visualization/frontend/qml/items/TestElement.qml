// Copyright (C) 2022 twyleg
import QtQuick 2.0

AnimatedColumnElement {

	id: animatedColumnElement

	property alias text: numberText.text

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
		id: numberText

		anchors.fill: parent
		font.pixelSize: 40
		horizontalAlignment: Qt.AlignHCenter
	}

    Text {
        anchors.left: numberText.right
        font.pixelSize: 40
        text: driverModel.place
        color: "white"
    }

	MouseArea {
		anchors.fill: parent
		onClicked: parent.clicked()
	}

	function clicked() {
		moveToPosition(0)
	}

    function foo() {
        console.log("test")
        moveToPosition(driverModel.place)
    }

    Component.onCompleted: {
        driverModel.place_changed.connect(foo)
    }

//    Connections {
//        target: driverModel
//        onplace_changed: {
//            moveToPosition(driverModel.place)
//        }
//    }

}
