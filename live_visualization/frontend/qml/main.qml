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
            source: "../fonts/Exo-Bold.otf"
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

        anchors.fill: parent

        cache: false
        source: "image://stream/" + id

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

        Text {
            id: title
            font.family: fontLoader.name
            text: "Race Against AI"
            color: "black"
            x: parent.width / 2 - width / 2
            y: parent.height / 2 - height / 2
            font.pointSize: window.height * 0.05
        }
    }

    Svg {
        id: logoVolkswagen
        source: "./../images/img/Volkswagen_logo_2019.svg"
//        x: parent.width - parent.width*0.99
//        y: parent.height - parent.height*0.99
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.01
        anchors.topMargin: parent.height * 0.01
        fillMode: Image.PreserveAspectFit
        height: parent.height * 0.09


    }

    Svg {
        id: logoAutostadt
        source: "./../images/img/Autostadt_Logo.svg"
//        x: parent.width - parent.width*0.95
//        y: parent.height - parent.height*0.99
        anchors.top: logoVolkswagen.top
        anchors.left: logoVolkswagen.right
        anchors.leftMargin: parent.width * 0.01
        fillMode: Image.PreserveAspectFit
        height: parent.height*0.09
    }

    Svg {
        id: ngitl_logo
        source: "./../images/img/ngitl_black.svg"
        visible: true
        anchors.top: parent.top
        anchors.right: parent.right
        fillMode: Image.PreserveAspectFit
        height: parent.height * 0.09
    }

    Sectors {
        id: sectors
        anchors.fill: parent
    }
//Item {
//	id: aiviewItem
//	anchors.fill: parent

//	AIView {
//		id: aiview
//		anchors.fill: parent
//	}
//}
//    Text {
//        id: test_text
//        text: "test"
//        visible: true
//    }

    Connections {
        target: live_visualization_model

        function onReloadImage() {
            testImage.reload()

        }
    }
}
