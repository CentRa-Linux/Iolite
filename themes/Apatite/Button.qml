import Apatite 1.0
// Copyright (C) 2022 smr.
// SPDX-License-Identifier: LGPL-3.0-only
// http://s-m-r.ir
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.15 as Kirigami

T.Button {
    id: control

    property alias radius: background.radius
    property bool active: true
    property bool p: mouseArea.pressed || control.down

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset, implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset, implicitContentHeight + topPadding + bottomPadding)
    padding: 6
    spacing: 6
    icon.width: 24
    icon.height: 24
    icon.color: systemPalette.buttonText
    display: AbstractButton.TextOnly
    hoverEnabled: true

    SystemPalette {
        id: systemPalette

        colorGroup: control.enabled ? control.active ? SystemPalette.Active : SystemPalette.Inactive : SystemPalette.Disabled
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true
        onClicked: control.clicked()
    }

    Rectangle {
        id: effect

        property int mousex: width != background.width ? (1 - width / control.width) * mouseArea.mouseX : 0
        property int mousey: height != background.height ? (1 - height / control.height) * mouseArea.mouseY : 0

        radius: 4
        color: systemPalette.highlight
        x: mousex + background.anchors.margins
        y: mousey + background.anchors.margins
        width: mouseArea.containsMouse ? background.width : 0
        height: mouseArea.containsMouse ? background.height : 0
        opacity: mouseArea.containsMouse ? p ? 0.16 : 0.08 : 0

        Behavior on width {
            enabled: !marginanimation.running

            NumberAnimation {
                duration: Kirigami.Units.longDuration
                easing.type: Easing.OutQuad
            }

        }

        Behavior on height {
            enabled: !marginanimation.running

            NumberAnimation {
                duration: Kirigami.Units.longDuration
                easing.type: Easing.OutQuad
            }

        }

        Behavior on opacity {
            NumberAnimation {
                duration: Kirigami.Units.longDuration
                easing.type: Easing.OutQuad
            }

        }

    }

    Rectangle {
        id: focusEffect

        anchors.fill: background
        anchors.margins: 5
        color: "transparent"
        border.color: systemPalette.highlight
        border.width: 2
        radius: 4
        opacity: control.focus && !p ? 0.3 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: Kirigami.Units.longDuration
                easing.type: Easing.OutQuad
            }

        }

    }

    contentItem: Item {
        Grid {
            anchors.centerIn: parent
            spacing: control.display == AbstractButton.TextOnly || control.display == AbstractButton.IconOnly ? 0 : control.spacing
            rows: 2
            columns: 2
            flow: control.display == AbstractButton.TextUnderIcon ? Grid.TopToBottom : Grid.LeftToRight
            layoutDirection: control.mirrored ? Qt.RightToLeft : Qt.LeftToRight
            horizontalItemAlignment: Grid.AlignHCenter
            verticalItemAlignment: Grid.AlignVCenter

            Kirigami.Icon {
                visible: control.display != AbstractButton.TextOnly
                source: control.icon.name
                implicitHeight: control.icon.height
                implicitWidth: control.icon.width
            }

            Text {
                visible: control.display != AbstractButton.IconOnly
                text: control.text
                font: control.font
                color: systemPalette.buttonText
            }

        }

    }

    background: Rectangle {
        id: background

        property real translucent: mouseArea.containsMouse || control.down ? p ? 0 : 0.5 : 1
        property string bordercolor: control.highlighted ? Apatite.pblend(systemPalette.button, systemPalette.highlight, 0.5) : Apatite.pblend(systemPalette.button, systemPalette.buttonText, 0.7)

        anchors.fill: parent
        anchors.margins: mouseArea.containsMouse || control.down ? p ? 3 : 0 : 0
        radius: 4
        color: control.highlighted ? Apatite.pblend(systemPalette.button, systemPalette.highlight, 0.9) : control.flat ? "transparent" : systemPalette.button
        border.width: 1
        border.color: mouseArea.containsMouse || control.down ? p ? systemPalette.highlight : bordercolor : control.flat ? "transparent" : bordercolor

        Behavior on anchors.margins {
            NumberAnimation {
                id: marginanimation

                duration: Kirigami.Units.longDuration
                easing.type: Easing.OutQuad
            }

        }

        Behavior on translucent {
            NumberAnimation {
                duration: Kirigami.Units.longDuration
                easing.type: Easing.OutQuad
            }

        }

        Behavior on color {
            ColorAnimation {
                duration: Kirigami.Units.longDuration
                easing.type: Easing.OutQuad
            }

        }

        Behavior on border.color {
            ColorAnimation {
                duration: Kirigami.Units.longDuration
                easing.type: Easing.OutQuad
            }

        }

    }

}
