import QtQuick 2.15
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14
import org.kde.kirigami 2.15 as Kirigami

Item {
    id: root
    width: 100
    height: parent.height

    property string iconname
    property bool checked: false
    Column {
        Rectangle {
            id: background
            color: Kirigami.Theme.highlightColor
            opacity: mousearea.containsMouse ? mousearea.pressed ? 0.3 : 0.1 : 0
            width: root.width
            height: root.height - effect.height

            Behavior on opacity  {
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

            Behavior on height  {
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
        onClicked: if (parent.checked) {
            parent.checked = false;
        } else {
            parent.checked = true;
            window.requestActivate();
        }
    }

    Window {
        id: window
        flags: Qt.Window | Qt.CustomizeWindowHint// | Qt.Tool

        property int animation: 0
        property int direction: 0
        property int availableGeometryX: 0
        property int availableGeometryY: 0
        property int sx: direction == 0 || direction == 1 ? availableGeometryX : availableGeometryX + Screen.desktopAvailableWidth - width
        property int sy: direction == 1 || direction == 3 ? availableGeometryY : availableGeometryX + Screen.desktopAvailableHeight - height
        property int hx: direction == 0 || direction == 1 ? -width : Screen.width
        property int hy: direction == 1 || direction == 3 ? -height : Screen.height

        x: root.checked ? sx : animation == 2 ? hx : sx
        y: root.checked ? sy : animation == 1 ? hy : sy

        Behavior on x  {
            NumberAnimation {
                id: xanimation
                duration: Kirigami.Units.shortDuration
                easing.type: Easing.OutQuad
            }
        }
        Behavior on y  {
            NumberAnimation {
                id: yanimation
                duration: Kirigami.Units.shortDuration
                easing.type: Easing.OutQuad
            }
        }

        color: Kirigami.Theme.backgroundColor
        objectName: "window"
        visible: root.checked || xanimation.running || yanimation.running
        onActiveChanged: !active ? root.checked = false : root.checked = root.checked

        RowLayout {
            id: row
            objectName: "row"
            anchors.fill: parent
            visible: !window.vertical
        }
        ColumnLayout {
            id: column
            objectName: "column"
            anchors.fill: parent
            visible: window.vertical
        }
    }
    onCheckedChanged: {
        print(Screen.virtualX);
    }
}
