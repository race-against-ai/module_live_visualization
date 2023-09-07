import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    height: parent.height
    width: parent.width
    text: parent.text

    background: Rectangle {
        color: "black"
        radius: 5
        border.color: "grey"
        border.width: 2
        z: 1

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: {
                background.color = "grey"
            }
            onExited: {
                background.color = "black"
            }
            onClicked: {
                parent.parent.onClicked()
            }
        }
    }

    Text {
        text: parent.text
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        color: "white"
        font.family: fontLoaderWide.name
        font.pixelSize: parent.height * 0.4
        z: 2
    }
}
