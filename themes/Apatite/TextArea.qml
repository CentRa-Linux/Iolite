// Copyright (C) 2022 smr.
// SPDX-License-Identifier: LGPL-3.0-only
// http://s-m-r.ir
import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import QtQuick.Controls 2.15
import org.kde.kirigami 2.15 as Kirigami
import Apatite 1.0

T.TextArea {
    id: control

    SystemPalette {
        id: systemPalette
        colorGroup: control.enabled ? SystemPalette.Active : SystemPalette.Disabled
    }

    implicitWidth: Math.max(
                       contentWidth + leftPadding + rightPadding,
                       implicitBackgroundWidth + leftInset + rightInset,
                       placeholder.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(
                        contentHeight + topPadding + bottomPadding,
                        implicitBackgroundHeight + topInset + bottomInset,
                        placeholder.implicitHeight + topPadding + bottomPadding)

    padding: 6
    leftPadding: padding + 4

    color: systemPalette.text
    selectionColor: systemPalette.highlight
    selectedTextColor: systemPalette.highlightedText
    placeholderTextColor: Apatite.pblend(systemPalette.button,
                                         systemPalette.buttonText, 0.7)

    Text {
        id: placeholder
        property int textvisible: !control.length && !control.preeditText
                                  && (!control.activeFocus
                                      || control.horizontalAlignment !== Qt.AlignHCenter)
        x: control.leftPadding
        y: control.topPadding
        width: control.width - (control.leftPadding + control.rightPadding)
        height: control.height - (control.topPadding + control.bottomPadding)

        text: control.placeholderText
        font: control.font

        color: control.placeholderTextColor

        verticalAlignment: control.verticalAlignment
        opacity: textvisible ? 1 : 0
        elide: Text.ElideRight
        renderType: control.renderType

        Behavior on x {
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

    background: Rectangle {
        implicitWidth: 200
        implicitHeight: 200

        radius: 4

        color: systemPalette.button

        border.color: control.activeFocus ? systemPalette.highlight : Apatite.pblend(
                                                systemPalette.button,
                                                systemPalette.buttonText, 0.7)

        border.width: 1

        Behavior on border.color {
            ColorAnimation {
                duration: Kirigami.Units.longDuration
                easing.type: Easing.OutQuad
            }
        }
    }
}
