// Copyright (C) 2022 twyleg
import QtQuick 2.0


Item {

	id: animatedColumn

	property int margin: 0
	property int arrangementDuration: 500
	property list<AnimatedColumnElement> elementList


	function sortElements() {

		var newElementList = [];

		for (var i = 0; i < elementList.length; i++) {
			for (var j = 0; j < elementList.length; j++) {
				var e = elementList[j]
				if (e.position === i) {
					newElementList.push(e)
					break;
				}
			}
		}

		elementList = newElementList
	}

	function arrangeElements(animated = true) {
		var y = 0
		for (var i = 0; i < elementList.length; i++)  {
			var e = elementList[i];

			if (animated) {
				e.moveToY(y, arrangementDuration)
			} else {
				e.y = y
			}

			y += e.height + margin
		}
	}

	Component.onCompleted: {
		var y = 0;
		for (var i = 0; i < elementList.length; i++)  {
			var e = elementList[i];

			e.parent = animatedColumn;
			e.position = i
			e.y = y

			y += e.height + margin
		}
	}

}
