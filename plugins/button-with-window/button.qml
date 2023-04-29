import QtQuick 2.15
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14
import QtQuick.Window 2.14
import org.kde.kirigami 2.15 as Kirigami

Item {
    id: root

    property string iconname
    property bool checked: false

    width: 100
    height: parent.height
    onCheckedChanged: {
        print(Screen.virtualX);
    }

    Column {
        Rectangle {
            id: background

            color: Kirigami.Theme.highlightColor
            opacity: mousearea.containsMouse ? mousearea.pressed ? 0.3 : 0.1 : 0
            width: root.width
            height: root.height - effect.height

            Behavior on opacity {
                NumberAnimation {
                    duration: Kirigami.Units.shortDuration
                    easing.type: Easing.OutQuad
                }

            }

        }

        Rectangle {
            id: effect

            color: Kirigami.Theme.highlightColor
            width: root.width
            height: checked || mousearea.pressed ? mousearea.pressed ? 4 : 1 : 0

            Behavior on height {
                NumberAnimation {
                    duration: Kirigami.Units.shortDuration
                    easing.type: Easing.OutQuad
                }

            }

        }

    }

    Kirigami.Icon {
        id: icon

        anchors.centerIn: parent
        source: iconname
        width: Kirigami.Units.iconSizes.smallMedium
        height: Kirigami.Units.iconSizes.smallMedium
        onSourceChanged: {
            print(iconname);
        }
    }

    MouseArea {
        id: mousearea

        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            if (parent.checked) {
                parent.checked = false;
                window.setting = false;
            } else {
                parent.checked = true;
                window.setting = false;
                window.requestActivate();
            }
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

        //flags: Qt.FramelessWindowHint
        x: root.checked ? sx : animation == 2 ? hx : sx
        y: root.checked ? sy : animation == 1 ? hy : sy
        color: Kirigami.Theme.backgroundColor
        objectName: "window"
        visible: (root.checked || xanimation.running || yanimation.running) && !setting

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
