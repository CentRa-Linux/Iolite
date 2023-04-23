// Copyright (C) 2022 smr.
// SPDX-License-Identifier: LGPL-3.0-only
// http://s-m-r.ir
import QtQuick 2.15
import QtQuick.Shapes 1.4
import QtQuick.Templates 2.15 as T
import QtQuick.Controls 2.15
import org.kde.kirigami 2.15 as Kirigami
import Apatite 1.0

T.Dial {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    SystemPalette {
        id: systemPalette
        colorGroup: control.enabled ? SystemPalette.Active : SystemPalette.Disabled
    }

    background: Shape {
        id: outerCircle
        width: control.width
        height: control.height
        ShapePath {
            strokeWidth: control.pressed ? 5 : 2
            strokeColor: systemPalette.highlight
            capStyle: ShapePath.RoundCap
            fillColor: "transparent"
            startX: 0
            startY: 0
            Behavior on strokeWidth {
                NumberAnimation {
                    duration: Kirigami.Units.longDuration
                    easing.type: Easing.OutQuad
                }
            }
            PathAngleArc {
                id: arc1
                centerX: control.width / 2
                centerY: control.height / 2
                radiusX: control.width / 2
                radiusY: control.height / 2
                startAngle: -230
                sweepAngle: control.angle + 140
            }
        }
    }

    handle: Item {
        width: control.width
        height: control.height

        rotation: control.angle

        Rectangle {
            width: control.width
            height: control.height
            color: "transparent"
            Rectangle {
                anchors.fill: parent
                anchors.margins: control.pressed ? 2 : 0
                radius: width
                border.color: hovered ? systemPalette.highlight : Apatite.pblend(
                                            systemPalette.button,
                                            systemPalette.buttonText, 0.7)
                color: systemPalette.window
                Behavior on anchors.margins {
                    NumberAnimation {
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

        Rectangle {
            x: (parent.width - width) / 2
            y: 12
            width: 2
            height: 10
            radius: width
            color: systemPalette.text
        }
    }
}
