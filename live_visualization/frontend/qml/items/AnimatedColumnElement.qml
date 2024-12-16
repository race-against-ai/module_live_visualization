// Copyright (C) 2023 twyleg
import QtQuick 2.0

Item {

	id: animatedColumnElement

	property int position

	property bool movingUp: false
	property bool movingDown: false

	PropertyAnimation {
		id: animation
		target: animatedColumnElement
		property: "y"
		to: 0
		duration: 0
		running: false

		onStopped: {
			movingUp = false
			movingDown = false
		}
	}

	function moveToPosition(newPosition) {
		parent.moveElement(position, newPosition)
	}

	function moveToY(y, duration) {

		movingUp = y < animatedColumnElement.y
		movingDown = y > animatedColumnElement.y

		animatedColumnElement.z = movingUp ? 1 : 0

		animation.to = y
		animation.duration = duration
		animation.start()
	}
}
