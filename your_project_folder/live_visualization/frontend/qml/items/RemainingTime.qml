import QtQuick 2.0

Item {
    id: remainingTimeItem

    FontLoader {
               id: fontLoader
               source: "../../fonts/Exo-Bold.otf"
           }

    Text {
        id: remainingTime
        anchors.fill: parent
        font.pixelSize: window.width * 0.01
        text: "Verbleibende Zeit:" + String(countdown.seconds).padStart(2, '0') //+ ":" + String(countdown_model.secs).padStart(2, '0')
        font.family: fontLoader.name
    }

    Timer {
        id: countdown
        onTriggered: {
            countDown.seconds--;
            if (countdown.seconds == 0) {
                running = false;
                countdown.seconds = countdown.defaultSeconds
                countdown.opacity = 0
                countdown.triggert()
                }
        }



    }

    function start () {
        seconds = 180
        countdown.start()
    }

    function stop() {
        countdown.stop()
    }


}

//String(timer_model.seconds).padStart(2, '0')
