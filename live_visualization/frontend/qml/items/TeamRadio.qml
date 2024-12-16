import QtQuick 2.15

Item {
    property int xValue: window.width + background.width
    anchors.fill: parent

    Behavior on xValue {
        NumberAnimation {
            duration: 250
        }
    }

    Svg {
        id: background
        source: "./../../images/img/team_radio_background.svg"
        x: xValue - width
        y: window.height * 0.2
        anchors.fill: Image.PreserveAspectFit
        height: window.height * 0.1
    }

    Svg {
        id: teamRadioText
        source: "./../../images/img/team_radio_text.svg"
        x: xValue - width
        y: window.height * 0.2
        anchors.fill: Image.PreserveAspectFit
        height: window.height * 0.1
    }

    Svg {
        id: audioGraphics
        source: "./../../images/img/team_radio_audio_graphic.svg"
        x: xValue - width
        y: window.height * 0.2
        anchors.fill: Image.PreserveAspectFit
        height: window.height * 0.1
    }

    Connections {
        target: live_visualization_model

        function onSoundStopped() {
            xValue = window.width + background.width
        }

        function onSoundStarted() {
            xValue = window.width
        }
    }
}
