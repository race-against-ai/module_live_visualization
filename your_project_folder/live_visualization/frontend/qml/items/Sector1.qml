import QtQuick 2.0

Item {
    id: sectorOne
    property string sector_color: t_model.sector_one_color

    Svg {
        anchors.fill: parent
        source: "../../images/svg_extracted_layers/sectors_sector1_grey.svg"
        x: parent.width * 0.11
        y: parent.height * 0.225
        visible: sectorOne.sector_color === "grey" ? true : false
    }

    Svg {
        anchors.fill: parent
        source: "../../images/svg_extracted_layers/sectors_sector1_green.svg"
        x: parent.width * 0.11
        y: parent.height * 0.225
        visible: sectorOne.sector_color === "green" ? true : false
    }

    Svg {
        anchors.fill: parent
        source: "../../images/svg_extracted_layers/sectors_sector1_yellow.svg"
        x: parent.width * 0.11
        y: parent.height * 0.225
        visible: sectorOne.sector_color === "yellow" ? true : false

    }

    Svg {
        anchors.fill: parent
        source: "../../images/svg_extracted_layers/sectors_sector1_purple.svg"
        x: parent.width * 0.11
        y: parent.height * 0.225
        visible: sectorOne.sector_color === "purple" ? true : false
    }
}
