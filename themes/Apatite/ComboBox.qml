// Copyright (C) 2022 smr.
// SPDX-License-Identifier: LGPL-3.0-only
// http://s-m-r.ir
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.15 as Kirigami
import Apatite 1.0

T.ComboBox {
    id: control

    SystemPalette {
        id: systemPalette
        colorGroup: control.enabled ? SystemPalette.Active : SystemPalette.Disabled
    }

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(
                        implicitBackgroundHeight + topInset + bottomInset,
                        implicitContentHeight + topPadding + bottomPadding,
                        implicitIndicatorHeight + topPadding + bottomPadding)
    leftPadding: 5 + (!control.mirrored || !indicator
                      || !indicator.visible ? 0 : indicator.width + spacing)
    rightPadding: 5 + (control.mirrored || !indicator
                       || !indicator.visible ? 0 : indicator.width + spacing)
    spacing: 0
    pressed: mouseArea.pressed

    property bool p: mouseArea.pressed || control.down

    delegate: ItemDelegate {
        width: ListView.view.width
        text: control.textRole ? (Array.isArray(
                                      control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData
        palette.text: systemPalette.buttonText
        palette.highlightedText: systemPalette.highlightedText
        hoverEnabled: control.hoverEnabled

        background: Rectangle {
            radius: 4
            color: control.currentIndex
                   === index ? Apatite.setAlpha(
                                   systemPalette.highlight,
                                   0.2) : pressed ? Apatite.setAlpha(
                                                        systemPalette.highlight,
                                                        0.1) : systemPalette.window
            opacity: control.currentIndex === index || hovered ? 1 : 0

            border.width: 1
            border.color: systemPalette.highlight
            Behavior on opacity {
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

            Rectangle {
                x: parent.width * 0.9
                y: (parent.height - height) / 2
                width: 5
                height: 5
                radius: width
                color: systemPalette.buttonText
                visible: control.currentIndex === index
            }
        }
    }

    indicator: Kirigami.Icon {
        x: control.mirrored ? control.padding : control.availableWidth + control.spacing + 4
        y: control.topPadding + (control.availableHeight - height) / 2
        source: "go-up"
        width: 12
        opacity: enabled ? 1 : 0.3
        rotation: control.down ? 0 : 180
        Behavior on rotation {
            NumberAnimation {
                duration: Kirigami.Units.longDuration
                easing.type: Easing.OutQuad
            }
        }
    }

    contentItem: T.TextField {
        leftPadding: !control.mirrored ? 12 : 13
        rightPadding: control.mirrored ? 12 : 13
        topInset: 5
        bottomInset: 5
        text: control.editable ? control.editText : control.displayText

        enabled: control.editable
        autoScroll: control.editable
        readOnly: !control.editable
        inputMethodHints: control.inputMethodHints
        validator: control.validator
        selectByMouse: control.selectTextByMouse

        font: control.font
        color: systemPalette.windowText
        selectionColor: systemPalette.highlight
        selectedTextColor: systemPalette.highlightedText
        verticalAlignment: Text.AlignVCenter

        background: Rectangle {
            visible: control.enabled && control.editable && !control.flat
            color: systemPalette.window
            opacity: parent.activeFocus && control.editable ? 0.9 : 0.6
            radius: 2
            Behavior on opacity {
                NumberAnimation {
                    duration: 100
                }
            }
        }
    }

    background: Rectangle {
        implicitWidth: 140
        implicitHeight: 40
        color: "transparent"

        Rectangle {
            id: background
            anchors.fill: parent
            anchors.margins: control.pressed ? 2 : 0

            property string bordercolor: control.down ? Apatite.pblend(
                                                            systemPalette.button,
                                                            systemPalette.highlight,
                                                            0.5) : Apatite.pblend(
                                                            systemPalette.button,
                                                            systemPalette.buttonText,
                                                            0.7)

            visible: !control.flat || control.down
            radius: 4
            color: control.down ? Apatite.pblend(systemPalette.button,
                                                 systemPalette.highlight,
                                                 0.9) : systemPalette.button
            border.width: 1
            border.color: control.pressed ? systemPalette.highlight : bordercolor

            Behavior on anchors.margins {
                NumberAnimation {
                    id: marginanimation
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

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: !control.down ? control.popup.open() : control.popup.close()
    }

    Rectangle {
        id: effect

        property int mousex: width != background.width ? (1 - width / control.width)
                                                         * mouseArea.mouseX : 0
        property int mousey: height != background.height ? (1 - height / control.height)
                                                           * mouseArea.mouseY : 0

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

    popup: T.Popup {
        y: visible ? control.height + 2 : 0
        topPadding: 0
        width: control.width
        height: Math.min(contentItem.implicitHeight,
                         control.Window.height - y - control.y)

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: control.delegateModel
            spacing: 0
            currentIndex: control.highlightedIndex
            highlightMoveDuration: 0
            T.ScrollIndicator.vertical: ScrollIndicator {}
        }

        background: Rectangle {
            radius: 4
            border.color: Apatite.pblend(systemPalette.button,
                                         systemPalette.buttonText, 0.7)
            color: systemPalette.window
        }
    }
}
