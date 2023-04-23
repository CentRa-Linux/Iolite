// Copyright (C) 2022 smr.
// SPDX-License-Identifier: LGPL-3.0-only
// http://s-m-r.ir
import QtQuick 2.15
import QtQuick.Shapes 1.4
import QtQuick.Templates 2.15 as T
import QtQuick.Controls 2.15
import org.kde.kirigami 2.15 as Kirigami
import Apatite 1.0

T.Switch {
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

    padding: 6
    spacing: 6

    indicator: Rectangle {
        id: root
        implicitWidth: 50
        implicitHeight: 25

        x: control.text ? (control.mirrored ? control.width - width - control.rightPadding : control.leftPadding) : control.leftPadding
                          + (control.availableWidth - width) / 2

        y: control.topPadding + (control.availableHeight - height) / 2
        color: "transparent"
        Rectangle {
            id: effect
            implicitWidth: parent.implicitWidth
            implicitHeight: parent.implicitHeight
            anchors.fill: parent
            anchors.margins: control.down ? 2 : 0
            color: control.checked ? Apatite.setAlpha(
                                         systemPalette.highlight,
                                         0.2) : systemPalette.window
            radius: 4

            border.color: control.hovered ? systemPalette.highlight : !control.checked ? Apatite.pblend(systemPalette.button, systemPalette.buttonText, 0.7) : Apatite.pblend(systemPalette.button, systemPalette.highlight, 0.2)
            border.width: 1

            Behavior on color {
                enabled: !control.down || marginanimation.running
                ColorAnimation {
                    duration: Kirigami.Units.longDuration
                    easing.type: Easing.OutQuad
                }
            }
            Behavior on border.color {
                enabled: !control.down || marginanimation.running
                ColorAnimation {
                    duration: Kirigami.Units.longDuration
                    easing.type: Easing.OutQuad
                }
            }

            Behavior on anchors.margins {
                NumberAnimation {
                    id: marginanimation
                    duration: Kirigami.Units.longDuration
                    easing.type: Easing.OutQuad
                }
            }

            Rectangle {
                id: focusEffect
                anchors.fill: parent
                anchors.margins: 2
                color: "transparent"
                border.color: systemPalette.highlight
                border.width: 2
                radius: 4
                opacity: control.focus && !control.down ? 0.3 : 0
                Behavior on opacity {
                    NumberAnimation {
                        duration: Kirigami.Units.longDuration
                        easing.type: Easing.OutQuad
                    }
                }
            }

            Shape {
                id: line
                anchors.verticalCenter: parent.verticalCenter
                ShapePath {
                    strokeWidth: 2
                    strokeColor: effect.border.color
                    capStyle: ShapePath.RoundCap
                    fillColor: "transparent"
                    startX: effect.width / 4
                    startY: -root.height / 5
                    PathLine {
                        id: line1
                        relativeX: 0
                        relativeY: control.checked ? root.height / 2.5 : 0
                        Behavior on relativeY {
                            NumberAnimation {
                                duration: Kirigami.Units.longDuration
                                easing.type: Easing.OutQuad
                            }
                        }
                    }
                }
            }

            Shape {
                id: circle
                anchors.verticalCenter: parent.verticalCenter
                ShapePath {
                    strokeWidth: 2
                    strokeColor: effect.border.color
                    capStyle: ShapePath.RoundCap
                    fillColor: "transparent"
                    PathAngleArc {
                        id: arc1
                        centerX: effect.width * 3 / 4
                        radiusX: root.height / 5
                        radiusY: root.height / 5
                        startAngle: -90
                        sweepAngle: !control.checked ? 360 : 0
                        Behavior on sweepAngle {
                            NumberAnimation {
                                duration: Kirigami.Units.longDuration
                                easing.type: Easing.OutQuad
                            }
                        }
                    }
                }
            }

            Rectangle {
                id: ibox
                x: Math.min(
                       Math.max(
                           y,
                           control.visualPosition * parent.width - height / 2),
                       parent.width - height - y)
                y: 0

                color: Apatite.pblend(systemPalette.highlight,
                                      systemPalette.button, visualPosition)

                border.color: control.hovered ? systemPalette.highlight : Apatite.pblend(
                                                    systemPalette.highlight,
                                                    Apatite.pblend(
                                                        systemPalette.button,
                                                        systemPalette.buttonText,
                                                        0.7), visualPosition)
                border.width: 1

                width: height
                height: parent.height

                radius: 4

                Behavior on color {
                    enabled: !control.down
                    ColorAnimation {
                        duration: Kirigami.Units.longDuration
                        easing.type: Easing.OutQuad
                    }
                }

                Behavior on border.color {
                    enabled: !control.down
                    ColorAnimation {
                        duration: Kirigami.Units.longDuration
                        easing.type: Easing.OutQuad
                    }
                }

                Behavior on x {
                    enabled: !control.down
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
        text: control.text
        font: control.font
        color: systemPalette.windowText
    }
}
