import QtQuick 2.0

Item {
    id: sectorTwo
    property string sector_color: t_model.sector_two_color

    Svg {
        anchors.fill: parent
        source: "../../images/svg_extracted_layers/sectors_sector2_grey.svg"
        x: parent.width * 0.25
        y: parent.height * 0.225
        visible: sectorTwo.sector_color === "grey" ? true : false
    }

    Svg {
        anchors.fill: parent
        source: "../../images/svg_extracted_layers/sectors_sector2_green.svg"
        x: parent.width * 0.25
        y: parent.height * 0.225
        visible: sectorTwo.sector_color === "green" ? true : false
    }

    Svg {
        anchors.fill: parent
        source: "../../images/svg_extracted_layers/sectors_sector2_yellow.svg"
        x: parent.width * 0.25
        y: parent.height * 0.225
        visible: sectorTwo.sector_color === "yellow" ? true : false
    }

    Svg {
        anchors.fill: parent
        source: "../../images/svg_extracted_layers/sectors_sector2_purple.svg"
        x: parent.width * 0.22
        y: parent.height * 0.225
        visible: sectorTwo.sector_color === "purple" ? true : false
    }
}
