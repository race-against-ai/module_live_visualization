// Copyright (C) 2022 twyleg
import QtQuick 2.0


Item {

	id: animatedColumn

	property int margin: 0
	property int rearrangementDuration: 500
	property list<AnimatedColumnElement> elementList


	function moveElement(src, dst) {
		console.log("Moving: "+ src + " -> " + dst);

		var newElementList = [];
		var newElementPosition = 0;

		for (var i = 0; i < dst; i++) {
			var e = elementList[i]
			e.position = newElementPosition++
			newElementList.push(e);
		}

		var e = elementList[src]
		e.position = newElementPosition++
		newElementList.push(e);


		for (i = dst; i < elementList.length; i++) {
			e = elementList[i];
			if(e !== elementList[src]) {
				e.position = newElementPosition++
				newElementList.push(e)
			}
		}


		elementList = newElementList
		rearrangeElements();
	}

	function rearrangeElements() {
		var y = 0
		for (var i = 0; i < elementList.length; i++)  {
			var e = elementList[i];
			e.moveToY(y, rearrangementDuration)

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
