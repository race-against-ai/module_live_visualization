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

        id: stream

        property int id: 0

        anchors.fill: parent
        fillMode: Image.PreserveAspectFit

        visible: false

        cache: false
        source: "image://stream/" + id

        function reload() {
            id++;
        }
    }

    Image {

        id: trackerStream

        property int id: 0

        anchors.fill: parent
        fillMode: Image.PreserveAspectFit

        visible: true

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

    CostumButton {
        id: trackerImageButton
        anchors.right: parent.right
        anchors.top: logoAutostadt.bottom
        height: parent.height * 0.05
        width: window.width * 0.1
        text: "Tracker View"

        onClicked: {
            console.log("Tracker View enabled!")
            trackerStream.visible = true
            stream.visible = false
        }
    }

    CostumButton {
        id: imageButton
        anchors.right: parent.right
        anchors.top: trackerImageButton.bottom
        height: parent.height * 0.05
        width: window.width * 0.1
        text: "VR View"

        onClicked: {
            console.log("Stream view enabled")
            stream.visible = true
            trackerStream.visible = false
        }
    }

    Connections {
        target: live_visualization_model

        function onReloadImage() {
            trackerStream.reload()
            stream.reload()
        }
    }
}
