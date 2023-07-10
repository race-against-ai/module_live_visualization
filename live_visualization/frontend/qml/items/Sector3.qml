import QtQuick 2.0

Item {
    id: sectorThree
    property string sector_color: t_model.sector_three_color

    Svg {
        anchors.fill: parent
        source: "../../images/svg_extracted_layers/sectors_sector3_grey.svg"
        x: parent.width * 0.25
        y: parent.height * 0.225
        visible: sectorThree.sector_color === "grey" ? true : false
    }

    Svg {
        anchors.fill: parent
        source: "../../images/svg_extracted_layers/sectors_sector3_green.svg"
        x: parent.width * 0.35
        y: parent.height * 0.225
        visible: sectorThree.sector_color === "green" ? true : false
    }

    Svg {
        anchors.fill: parent
        source: "../../images/svg_extracted_layers/sectors_sector3_yellow.svg"
        x: parent.width * 0.35
        y: parent.height * 0.225
        visible: sectorThree.sector_color === "yellow" ? true : false
    }

    Svg {
        anchors.fill: parent
        source: "../../images/svg_extracted_layers/sectors_sector3_purple.svg"
        x: parent.width * 0.23
        y: parent.height * 0.225
        visible: sectorThree.sector_color === "purple" ? true : false
    }
}
