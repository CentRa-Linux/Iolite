import QtQuick 2.15
import QtQuick.Templates 2.15 as T

T.Label {
    id: control

    SystemPalette {
        id: systemPalette
        colorGroup: control.enabled ? SystemPalette.Active : SystemPalette.Disabled
    }

    color: systemPalette.windowText
    linkColor: systemPalette.highlight
}
