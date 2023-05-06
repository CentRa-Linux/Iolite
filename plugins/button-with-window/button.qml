import QtQuick 2.15
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14
import QtQuick.Window 2.14
import org.kde.kirigami 2.15 as Kirigami
import Apatite 1.0

AnimatedButton {
    id: root

    implicitWidth: 100
    implicitHeight: parent.height
    display: AbstractButton.IconOnly
    checkable: true
    flat: true
    icon.name: ""
    onCheckedChanged: {
        if (checked) {
            window.setting = false;
            window.requestActivate();
            window.raise();
        } else {
            window.setting = false;
        }
    }

    Window {
        // onActiveChanged: {
        //     !active ? root.checked = false : root.checked = root.checked;
        //     console.error(root.iconname + ":" + active);
        // }

        id: window

        property int animation: 0
        property int direction: 0
        property int availableGeometryX: 0
        property int availableGeometryY: 0
        property int sx: direction == 0 || direction == 1 ? availableGeometryX : availableGeometryX + Screen.desktopAvailableWidth - width
        property int sy: direction == 1 || direction == 3 ? availableGeometryY : availableGeometryY + Screen.desktopAvailableHeight - height
        property int hx: direction == 0 || direction == 1 ? -width : Screen.width
        property int hy: direction == 1 || direction == 3 ? -height : Screen.height
        property int layoutType: 0 // 0 → Row 1 → Column 2 → Grid
        property bool setting: false

        flags: Qt.Tool
        x: root.checked ? sx : animation == 2 ? hx : sx
        y: root.checked ? sy : animation == 1 ? hy : sy
        color: Kirigami.Theme.backgroundColor
        objectName: "window"
        visible: (root.checked || xanimation.running || yanimation.running) && !setting

        MouseArea {
            id: overlay

            z: 999
            enabled: xanimation.running || yanimation.running
            anchors.fill: parent
        }

        RowLayout {
            id: row

            objectName: "row"
            anchors.fill: parent
            visible: window.layoutType == 0
        }

        ColumnLayout {
            id: column

            objectName: "column"
            anchors.fill: parent
            visible: window.layoutType == 1
        }

        Grid {
            id: grid

            objectName: "grid"
            anchors.fill: parent
            visible: window.layoutType == 1
        }

        Behavior on x {
            NumberAnimation {
                id: xanimation

                duration: Kirigami.Units.shortDuration
                easing.type: Easing.OutQuad
                onStopped: window.setting = false
            }

        }

        Behavior on y {
            NumberAnimation {
                id: yanimation

                duration: Kirigami.Units.shortDuration
                easing.type: Easing.OutQuad
                onStopped: parent.setting = false
            }

        }

    }

}
