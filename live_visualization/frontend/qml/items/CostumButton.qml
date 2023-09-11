import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    height: parent.height
    width: parent.width
    text: parent.text

    background: Rectangle {
        radius: 5
        border.color: "grey"
        border.width: 2
        z: 1

        gradient: Gradient {
            GradientStop {position: 0.0; color: "#1a1a1a" }
            GradientStop {position: 1.0; color: "#303030" }
        }

        MouseArea {
            z: 2
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
        z: 3
    }
}
