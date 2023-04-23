// Copyright (C) 2022 smr.
// SPDX-License-Identifier: LGPL-3.0-only
// http://s-m-r.ir
import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.15 as Kirigami
import Apatite 1.0

T.ProgressBar {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    SystemPalette {
        id: systemPalette
        colorGroup: control.enabled ? control.active ? activeSystemPalette.colorGroup : inactiveSystemPalette.colorGroup : disabledSystemPalette.colorGroup
    }

    property int orientation: Qt.Horizontal
    padding: 0

    QtObject {
        id: orient
        property bool vertical: control.orientation == Qt.Vertical
        property bool horizontal: control.orientation == Qt.Horizontal
    }

    contentItem: Item {
        Rectangle {
            x: 0
            y: (parent.height - height) / 2
            width: control.position * parent.width
            height: Math.min(width, parent.height)

            radius: Math.max(width, height)
            color: Apatite.pblend(systemPalette.button,
                                  systemPalette.highlight, 0.8)

            border {
                color: systemPalette.highlight
                width: 1
            }
        }
    }

    background: Rectangle {
        implicitWidth: orient.horizontal ? 200 : 8
        implicitHeight: orient.vertical ? 200 : 8

        color: 'transparent'
        radius: width

        border {
            color: Apatite.pblend(systemPalette.button,
                                  systemPalette.buttonText, 0.7)
            width: 1
        }
    }
}
