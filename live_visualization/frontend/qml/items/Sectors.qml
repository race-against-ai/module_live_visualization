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
        id: sectorsBackground
        source: "../../images/svg_extracted_layers/sectors_body.svg"
        x: parent.width - parent.width*0.35
        y: parent.height - parent.height*0.3
        height: parent.height*0.2
        width: parent.width*0.3
        visible: true


        Svg {
            source: "../../images/svg_extracted_layers/sectors_header.svg"
            anchors.fill: parent

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
                font.family: fontLoaderWide.name
                color: "black"
                font.pixelSize: parent.height*0.2
               // text: t_model.best_time
                text: sectors.best_time
            }
        }

        Text {
            id: time
            font.family: fontLoaderWide.name
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

    Svg {
        id: track
        source: "../../images/svg/holodeck_track_definition.svg"
        height: parent.height * 0.4
        fillMode: Image.PreserveAspectFit
        y: window.height * 0.95 - height
        x: window.width * 0.95 - width
        opacity: 0
    }

    Svg {
        id: switchButton
        source: "../../images/svg/switch-horizontal.svg"
        height: parent.height * 0.05
        fillMode: Image.PreserveAspectFit
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        Rectangle {
            id: switchBackground
            color: "grey"
            radius: 10
            opacity: 0.5
            visible: false
            anchors.fill: parent
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                switchBackground.visible = true;  // Show the background during the click
                if(sectorsBackground.x === sectors.width - sectors.width*0.35) {
                    xAnimation.to = window.width
                    opacityAnimation.to = 1
                } else {
                    xAnimation.to = sectors.width - sectors.width*0.35
                    opacityAnimation.to = 0
                }
                xAnimation.start()
                opacityAnimation.start()

                // Add a Timer to hide the background after a delay (e.g., 1 second)
                switchBackgroundTimer.running = true;
            }
        }

        Timer {
            id: switchBackgroundTimer
            interval: 100 // 1 second delay
            running: false
            onTriggered: {
                switchBackground.visible = false;  // Hide the background
                switchBackgroundTimer.running = false;
            }
        }
    }

    PropertyAnimation {
        id: xAnimation
        target: sectorsBackground
        property: "x"
        duration: 500
    }

    PropertyAnimation {
        id: opacityAnimation
        target: track
        property: "opacity"
        duration: 500
    }
}
