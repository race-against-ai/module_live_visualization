import QtQuick 2.0
import QtQuick.Controls 2.15

Item {
    id: sectors
    property string best_time:t_model.best_time
    property double split_time: t_model.split_time

    enum State {
        RESET = 0,
        RUNNING = 0,
        PAUSED = 0
    }

    FontLoader {
               id: fontLoader
               source: "../../fonts/Exo-Bold.otf"
           }

    Svg {
        source: "../../images/svg_extracted_layers/sectors_body.svg"
        x: parent.width - parent.width*0.35
        y: parent.height - parent.height*0.3
        height: parent.height*0.2
        width: parent.width*0.3


        Svg {
            source: "../../images/svg_extracted_layers/sectors_header.svg"
            anchors.fill: parent


            MouseArea {

                id: resetButtonMouseArea
                x: 0
                y: 0
                width: parent.width
                height:  parent.height

                onClicked: {
                    window.resetButtonClicked()
                }
                /*Rectangle{
                    anchors.fill: parent
                    color: "transparent"
                    border.color: "red"
                }*/
            }

            Text {
                id: textHeader
                anchors.top: parent.top
                anchors.topMargin: parent.height * 0.025
                horizontalAlignment: Text.AlignHCenter
                anchors.fill: parent
                font.family: fontLoaderWide.name
                color: "black"
                font.pixelSize: parent.height*0.1
                text: "Aktuelle Bestzeit"
            }
            Text {
                anchors.top: textHeader.bottom
                anchors.topMargin: parent.height * 0.15
                horizontalAlignment: Text.AlignHCenter
                anchors.fill: parent
                font.family: fontLoader.name
                color: "black"
                font.pixelSize: parent.height*0.2
               // text: t_model.best_time
                text: sectors.best_time
            }
        }

        Text {
            id: time
            font.family: fontLoader.name
            visible: !deltaTimer.running
            color: "white"
            font.pixelSize: parent.height*0.2
            text: String(t_model.minutes).padStart(2, '0') + ":" + String(t_model.seconds).padStart(2, '0') + "." + String(t_model.millis).padStart(3, '0')
           // x: parent.width * 0.3
            //text: "00:17:563"
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.45

            MouseArea {

                id: startStopButtonMouseArea
                x: 0
                y: 0
                width: parent.width
                height:  parent.height

                onClicked: {
                    window.startStopButtonClicked()
                }
                /*Rectangle{
                    anchors.fill: parent
                    color: "transparent"
                    border.color: "red"
                }*/
            }

        }

        Text{
            id: deltaTime
            font.family: fontLoader.name
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.45
            visible: deltaTimer.running
            font.pixelSize: parent.height*0.2
            text: sectors.split_time > 0 ? "+"+String(sectors.split_time.toFixed(3)) : String(sectors.split_time.toFixed(3))
            color: sectors.split_time > 0 ? "yellow" : "green"

        }

       Item{
           id: sectorOneItem
           anchors.fill: parent

           Sector1 {
               id: sectorOne
               anchors.fill: parent
           }
       }

       Item{
           id: sectorTwoItem
           anchors.fill: parent

           Sector2 {
               id: sectorTwo
               anchors.fill: parent
           }
       }

       Item{
           id: sectorThreeItem
           anchors.fill: parent

           Sector3 {
               id: sectorThree
               anchors.fill: parent
           }
       }


    Timer{
        id: deltaTimer
        running: false
        interval: 1500
        repeat: false
    }

    Connections{
        target: t_model
        onSplit_time_changed: function(){
            deltaTimer.start()
        }
    }
  }
}
