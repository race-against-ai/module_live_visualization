import QtQuick 2.0

AnimatedColumnElement {

    id: animatedColumnElement

    property alias text: numberText.text

    property color inactiveColor: "#562723"
    property color activeColor: "red"

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

    MouseArea {
        anchors.fill: parent
        onClicked: parent.clicked()
    }

    function clicked() {
        moveToPosition(0)
    }

}
