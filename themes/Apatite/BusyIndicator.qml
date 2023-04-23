import QtQuick 2.15
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.15 as Kirigami
import Apatite 1.0

T.BusyIndicator {
    id: control

    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                            implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                             implicitContentHeight + topPadding + bottomPadding)

    SystemPalette {
        id: systemPalette
        colorGroup: control.enabled ? SystemPalette.Active : SystemPalette.Disabled
    }

    visible: running
    running: false
    padding: 6

    contentItem: Rectangle {
        id: transparent
        color: "transparent"
        Rectangle {
            id: effect
            opacity: 1
            color: Kirigami.Theme.highlightColor
            anchors.centerIn: parent
            height: 4
            width: 20
            radius: 4
        }
        Rectangle {
            id: shadow1
            opacity: 0.5
            color: Kirigami.Theme.highlightColor
            anchors.centerIn: parent
            height: 4
            width: 20
            rotation: effect.rotation
            radius: 4

            Behavior on rotation {
                NumberAnimation {
                    duration: Kirigami.Units.longDuration
                    easing.type: Easing.OutQuad
                }
            }
        }
        Rectangle {
            id: shadow2
            opacity: 0.3
            color: Kirigami.Theme.highlightColor
            anchors.centerIn: parent
            height: 4
            width: 20
            rotation: effect.rotation
            radius: 4

            Behavior on rotation {
                NumberAnimation {
                    duration: Kirigami.Units.veryLongDuration
                    easing.type: Easing.OutQuad
                }
            }
        }
    }

    Timer {
        property real seed: 0
        running: control.running
        repeat: true
        interval: 25
        onTriggered: {
            effect.rotation += (Math.sin(seed += 0.1) + 1) / Math.PI * 10 + 2
        }
    }
    Component.onCompleted: print(control.enabled)
}
