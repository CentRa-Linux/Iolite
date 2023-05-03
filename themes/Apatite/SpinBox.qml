// Copyright (C) 2022 smr.
// SPDX-License-Identifier: LGPL-3.0-only
// http://s-m-r.ir
import QtQuick 2.15
import QtQuick.Shapes 1.15
import QtQuick.Templates 2.15 as T
import QtQuick.Controls 2.15
import org.kde.kirigami 2.15 as Kirigami
import Apatite 1.0

T.SpinBox {
    id: control

    SystemPalette {
        id: systemPalette
        colorGroup: control.enabled ? SystemPalette.Active : SystemPalette.Disabled
    }

    implicitWidth: Math.max(
                       implicitBackgroundWidth + leftInset + rightInset,
                       contentItem.implicitWidth + 2 * padding
                       + up.implicitIndicatorWidth + down.implicitIndicatorWidth)
    implicitHeight: Math.max(
                        implicitContentHeight + topPadding + bottomPadding,
                        implicitBackgroundHeight, up.implicitIndicatorHeight,
                        down.implicitIndicatorHeight)

    padding: 6
    leftPadding: padding + (control.mirrored ? (up.indicator ? up.indicator.width : 0) : (down.indicator ? down.indicator.width : 0))
    rightPadding: padding + (control.mirrored ? (down.indicator ? down.indicator.width : 0) : (up.indicator ? up.indicator.width : 0))
    font.bold: true

    validator: IntValidator {
        locale: control.locale.name
        bottom: Math.min(control.from, control.to)
        top: Math.max(control.from, control.to)
    }

    contentItem: TextInput {
        text: control.displayText

        font: control.font
        color: systemPalette.text
        selectionColor: systemPalette.highlight
        selectedTextColor: systemPalette.highlightedText
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        readOnly: !control.editable
        validator: control.validator
        inputMethodHints: control.inputMethodHints

        Rectangle {
            y: parent.height - height
            width: parent.width
            height: parent.readOnly ? 0 : 1
            color: control.palette.button
        }
    }

    up.indicator: Button {
        id: upbutton
        x: control.mirrored ? 0 : parent.width - width
        display: AbstractButton.IconOnly
        width: control.height
        height: control.height
        flat: true
        onClicked: control.increase()
        Shape {
            id: plus
            anchors.verticalCenter: parent.verticalCenter
            ShapePath {
                strokeWidth: 2
                strokeColor: upbutton.enabled ? systemPalette.text : disabledSystemPalette.text
                capStyle: ShapePath.RoundCap
                fillColor: "transparent"
                startX: upbutton.height / 2
                startY: -upbutton.height / 5
                PathLine {
                    id: line1
                    relativeX: 0
                    relativeY: upbutton.height / 2.5
                }
                PathMove {
                    id: move1
                    relativeX: -upbutton.height / 5
                    relativeY: -upbutton.height / 5
                }
                PathLine {
                    id: line2
                    relativeX: upbutton.height / 2.5
                    relativeY: 0
                }
            }
        }
    }

    down.indicator: Button {
        id: downbutton
        x: control.mirrored ? parent.width - width : 0
        display: AbstractButton.IconOnly
        width: control.height
        height: control.height
        flat: true
        onClicked: control.decrease()
        Shape {
            id: minus
            anchors.verticalCenter: parent.verticalCenter
            ShapePath {
                strokeWidth: 2
                strokeColor: downbutton.enabled ? systemPalette.text : disabledSystemPalette.text
                capStyle: ShapePath.RoundCap
                fillColor: "transparent"
                startX: upbutton.width * 1.5 / 5
                startY: 0
                PathLine {
                    id: line3
                    relativeX: upbutton.height / 2.5
                    relativeY: 0
                }
            }
        }
    }

    background: Rectangle {
        id: background
        implicitWidth: 120
        implicitHeight: 30

        radius: 4
        color: control.button
        border.width: 1
        border.color: Apatite.pblend(systemPalette.button,
                                     systemPalette.buttonText, 0.7)
    }
}
