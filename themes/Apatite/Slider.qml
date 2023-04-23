// Copyright (C) 2022 smr.
// SPDX-License-Identifier: LGPL-3.0-only
// http://s-m-r.ir
import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import QtQuick.Controls 2.15
import org.kde.kirigami 2.15 as Kirigami
import Apatite 1.0

T.Slider {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitHandleWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitHandleHeight + topPadding + bottomPadding)
    padding: 6

    SystemPalette {
        id: systemPalette
        colorGroup: control.enabled ? SystemPalette.Active : SystemPalette.Disabled
    }

    handle: Rectangle {
        x: control.leftPadding + (control.horizontal ? control.visualPosition * (control.availableWidth - width) : (control.availableWidth - width) / 2)
        y: control.topPadding
           + (control.horizontal ? (control.availableHeight - height) / 2 : control.visualPosition
                                   * (control.availableHeight - height))
        implicitWidth: 16
        implicitHeight: 16
        color: "transparent"
        Rectangle {
            anchors.fill: parent
            anchors.margins: control.pressed ? 2 : 0

            radius: height / 2
            border.width: 1
            border.color: control.hovered ? systemPalette.highlight : Apatite.pblend(
                                                systemPalette.button,
                                                systemPalette.buttonText, 0.7)
            color: control.hovered ? Apatite.pblend(systemPalette.button,
                                                    systemPalette.highlight,
                                                    0.8) : systemPalette.button
            Behavior on border.color {
                ColorAnimation {
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

            Behavior on anchors.margins {
                NumberAnimation {
                    duration: Kirigami.Units.longDuration
                    easing.type: Easing.OutQuad
                }
            }
        }
    }

    background: Rectangle {
        x: (control.width - width) / 2
        y: (control.height - height) / 2

        implicitWidth: control.horizontal ? 200 : 8
        implicitHeight: control.horizontal ? 8 : 200

        width: control.horizontal ? control.availableWidth : implicitWidth
        height: control.horizontal ? implicitHeight : control.availableHeight

        radius: height / 2

        border.width: 1
        border.color: Apatite.pblend(systemPalette.button,
                                     systemPalette.buttonText, 0.7)

        color: systemPalette.window

        Rectangle {
            x: 0
            anchors.verticalCenter: parent.verticalCenter

            implicitWidth: 20
            implicitHeight: parent.height

            radius: height / 2
            border.width: 1
            border.color: systemPalette.highlight

            width: control.leftPadding + (control.horizontal ? control.visualPosition * (control.availableWidth - 16) : (control.availableWidth - 16) / 2) + 8

            color: Apatite.pblend(systemPalette.button,
                                  systemPalette.highlight, 0.8)

            opacity: control.hovered ? 1 : 0.5

            Behavior on opacity {
                NumberAnimation {
                    duration: Kirigami.Units.longDuration
                    easing.type: Easing.OutQuad
                }
            }
        }
    }
}
