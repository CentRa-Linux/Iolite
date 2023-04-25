import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.14
import org.kde.kirigami 2.15 as Kirigami
import Apatite 1.0

Item {
    id: widget

    property var appModel

    Layout.minimumWidth: 200
    Layout.fillWidth: true
    height: parent.height

    Flickable {
        id: flickable

        width: parent.width
        height: parent.height
        contentWidth: parent.width
        contentHeight: grid.height

        Item {
            id: wrapper

            width: Math.max(parent.width, widget.width)
            height: Math.max(parent.height, grid.height)

            Grid {
                id: grid

                width: widget.width

                Repeater {
                    id: repeater

                    objectName: "repeater"
                    model: widget.appModel
                    onModelChanged: console.error("error")
                    Component.onCompleted: console.error(widget.appModel.get(0)["Icon"])

                    Button {
                        icon.name: Icon
                        icon.width: Kirigami.Units.iconSizes.medium
                        icon.height: Kirigami.Units.iconSizes.medium
                        visible: !Hidden && !NoDisplay
                        text: Name
                        flat: true
                        display: AbstractButton.TextUnderIcon
                        width: 100
                        height: 100
                        Component.onCompleted: print(index)
                    }

                }

            }

        }

    }

}
