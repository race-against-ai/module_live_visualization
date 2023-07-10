import QtQuick 2.0
import QtMultimedia 5.15

Item {

    id: aiview

    Svg {

        source: "../../images/svg_extracted_layers/oppTime_background.svg"
        //        x: parent.width * 0.001
        //        y: parent.height * 0.7
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.bottomMargin: parent.height * 0.08
        anchors.leftMargin: parent.width * 0.0275
        //width: parent.width * 0.25
        height: parent.height * 0.3

        Svg {
            source: "../../images/svg_extracted_layers/oppTime_cam.svg"
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.bottomMargin: parent.height * 0.025
            anchors.leftMargin: parent.width * 0.025
            width: parent.width * 0.95
            height: parent.height * 0.95

            // anchors.fill: parent
            Rectangle {
                anchors.fill: parent
                color: "black"
                border.width: 1
                border.color: "transparent"

                Video {
                    id: video
                    width: parent.width
                    height: parent.height
                    anchors.fill: parent

                    source: "file:///C:/Ideen_Expo/race_against_ai-pre_staging/software/live_view/live_visualization/frontend/images/img/race_against_ai_2.mp4"
                    anchors.centerIn: parent
                    muted: true

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            video.play()
                        }
                    }
                }
            }
        }
    }
}
