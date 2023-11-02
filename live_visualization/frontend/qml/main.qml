// Copyright (C) 2022 twyleg
import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import "./items"

Window {
    id: window

    width: 1280
    height: 720
    minimumWidth: 550
    visible: true
    visibility: "FullScreen"
    property bool isFullScreen: true
    // FullScreen or Windowed
    title: qsTr("Race against AI - Live view")

    color: "#FF404040"
    //signal start_stop_button_clicked
    signal reset_button_clicked
    signal state_changed

    FontLoader {
            id: fontLoader
            source: "../fonts/Formula1-Regular.otf"
    }

    FontLoader {
        id: fontLoaderWide
        source: "../fonts/Formula1-Bold.otf"
    }

    MouseArea {
        width: parent.width
        height: parent.height

        onClicked: {
            if(isFullScreen) {
                window.visibility = "Windowed"
            } else {
                window.visibility = "FullScreen"
            }
            isFullScreen = !isFullScreen
        }
    }


    Image {

        id: testImage

        property int id: 0

        anchors.centerIn: parent
        height: parent.height
        fillMode: Image.PreserveAspectFit

        cache: false
        source: "image://tracker_stream/" + id

        function reload() {
            id++;
        }
    }

    Rectangle {
        color: "grey"
        x: window.width / 2 - width / 2
        y: window.height * 0.01
        radius: 10
        width: title.width * 1.1
        height: window.height * 0.1
        opacity: 0.8

        Text {
            id: title
            font.family: fontLoaderWide.name
            text: "Race Against AI"
            color: "black"
            x: parent.width / 2 - width / 2
            y: parent.height / 2 - height / 2
            font.pointSize: window.height * 0.05
        }
    }

    Svg {
        id: logoAutostadt
        source: "./../images/img/Autostadt_Logo.svg"
        x: parent.width * 0.98 - width
        y: window.height * 0.01
        fillMode: Image.PreserveAspectFit
        height: parent.height*0.1
    }

    Sectors {
        id: sectors
        anchors.fill: parent
    }

    LeaderboardNew {
        id:leaderboardItem
        anchors.fill: parent
    }

    TeamRadio {
        id: teamRadio
        anchors.fill: parent
    }

    Connections {
        target: live_visualization_model

        function onReloadImage() {
            testImage.reload()
        }
    }
}
