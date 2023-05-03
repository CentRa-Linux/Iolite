// Copyright (C) 2022 smr.
// SPDX-License-Identifier: LGPL-3.0-only
// http://s-m-r.ir
import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import QtQuick.Shapes 1.4
import QtQuick.Controls 2.15
import org.kde.kirigami 2.15 as Kirigami
import Apatite 1.0

T.CheckBox {
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
                        implicitIndicatorHeight + topPadding + bottomPadding,
                        indicator.height + topPadding + bottomPadding)
    padding: 6
    spacing: 6

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
            anchors.margins: control.down ? 2 : 0
            radius: 4

            color: control.checkState == Qt.Unchecked ? systemPalette.button : Apatite.setAlpha(
                                                            systemPalette.highlight,
                                                            0.2)
            border.color: control.hovered ? systemPalette.highlight : control.checkState
                                            == Qt.Unchecked ? Apatite.pblend(
                                                                  systemPalette.button,
                                                                  systemPalette.buttonText,
                                                                  0.7) : Apatite.pblend(
                                                                  systemPalette.button,
                                                                  systemPalette.highlight,
                                                                  0.2)
            border.width: 1
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

        Shape {
            id: line
            anchors.centerIn: parent
            ShapePath {
                strokeWidth: 2
                strokeColor: systemPalette.highlight
                capStyle: ShapePath.RoundCap
                fillColor: "transparent"
                startX: -rect.width / 5
                startY: 0
                PathLine {
                    id: line1
                    relativeX: control.checkState == Qt.PartiallyChecked ? rect.width / 2.5 : 0
                    relativeY: 0
                    Behavior on relativeX {
                        NumberAnimation {
                            duration: Kirigami.Units.longDuration
                            easing.type: Easing.OutQuad
                        }
                    }
                }
            }
        }
        Shape {
            id: sp
            anchors.centerIn: parent
            ShapePath {
                strokeWidth: 2
                strokeColor: systemPalette.highlight
                capStyle: ShapePath.RoundCap
                fillColor: "transparent"
                startX: -rect.width / 5
                startY: 0
                PathLine {
                    id: p1
                    relativeX: 0
                    relativeY: 0
                }
                PathLine {
                    id: p2
                    relativeX: 0
                    relativeY: 0
                }
            }
        }
        SequentialAnimation {
            running: control.checked
            NumberAnimation {
                target: p1
                to: rect.width / 5 / 1.5
                properties: "relativeX, relativeY"
                duration: Kirigami.Units.longDuration / 2
                easing.type: Easing.InOutQuad
            }
            ParallelAnimation {
                NumberAnimation {
                    target: p2
                    to: rect.width * 2 / 1.5 / 5
                    property: "relativeX"
                    duration: Kirigami.Units.longDuration / 2
                    easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                    target: p2
                    to: -rect.width * 2 / 1.5 / 5
                    property: "relativeY"
                    duration: Kirigami.Units.longDuration / 2
                    easing.type: Easing.InOutQuad
                }
            }
        }
        SequentialAnimation {
            running: !control.checked
            ParallelAnimation {
                NumberAnimation {
                    target: p2
                    to: 0
                    property: "relativeX"
                    duration: Kirigami.Units.longDuration / 2
                    easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                    target: p2
                    to: 0
                    property: "relativeY"
                    duration: Kirigami.Units.longDuration / 2
                    easing.type: Easing.InOutQuad
                }
            }
            NumberAnimation {
                target: p1
                to: 0
                properties: "relativeX, relativeY"
                duration: Kirigami.Units.longDuration / 2
                easing.type: Easing.InOutQuad
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
        color: systemPalette.buttonText
    }

    Rectangle {
        id: focusEffect
        anchors.fill: rect
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
}
