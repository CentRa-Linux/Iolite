// Copyright (C) 2022 smr.
// SPDX-License-Identifier: LGPL-3.0-only
// http://s-m-r.ir
import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.15 as Kirigami
import Apatite 1.0

T.RadioButton {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(
                        implicitBackgroundHeight + topInset + bottomInset,
                        implicitContentHeight + topPadding + bottomPadding,
                        implicitIndicatorHeight + topPadding + bottomPadding)

    padding: 6
    spacing: 6

    SystemPalette {
        id: systemPalette
        colorGroup: control.enabled ? SystemPalette.Active : SystemPalette.Disabled
    }

    indicator: Rectangle {
        id: rect
        implicitWidth: 25
        implicitHeight: 25

        x: control.text ? (control.mirrored ? control.width - width - control.rightPadding : control.leftPadding) : control.leftPadding
                          + (control.availableWidth - width) / 2

        y: control.topPadding + (control.availableHeight - height) / 2
        color: "transparent"
        Rectangle {
            id: effect
            anchors.fill: parent
            anchors.margins: control.pressed ? 2 : 0
            radius: width
            color: !control.checked ? systemPalette.window : Apatite.setAlpha(
                                          systemPalette.highlight, 0.2)
            border.color: control.hovered ? systemPalette.highlight : !control.checked ? Apatite.pblend(systemPalette.button, systemPalette.buttonText, 0.7) : Apatite.pblend(systemPalette.button, systemPalette.highlight, 0.2)

            Behavior on anchors.margins {
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

            Rectangle {
                id: ibox
                x: (parent.width - width) / 2
                y: (parent.height - height) / 2

                width: control.checked ? parent.width - 16 : 0
                height: width

                color: systemPalette.highlight

                radius: width
                Behavior on width {
                    NumberAnimation {
                        duration: Kirigami.Units.longDuration
                        easing.type: Easing.OutQuad
                    }
                }
            }
        }
    }

    contentItem: Text {
        leftPadding: control.indicator
                     && !control.mirrored ? control.indicator.width + control.spacing : 0
        rightPadding: control.indicator
                      && control.mirrored ? control.indicator.width + control.spacing : 0
        verticalAlignment: Text.AlignVCenter
        color: systemPalette.windowText
        text: control.text
        font: control.font
    }
}
