import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.14
import org.kde.kirigami 2.15 as Kirigami
import Apatite 1.0

Item {
    id: widget

    property var appModel
    property int categoryWidth

    signal launch(string e)

    Layout.minimumWidth: 200
    Layout.fillWidth: true
    height: parent.height

    Row {
        anchors.fill: parent

        ScrollView {
            id: categoryFlickable

            width: widget.categoryWidth
            height: parent.height
            contentWidth: this.width
            contentHeight: content.height

            Rectangle {
                id: content

                width: parent.width
                height: grid.height
                color: "red"
            }

        }

        ScrollView {
            id: flickable

            width: parent.width - widget.categoryWidth
            height: parent.height
            contentWidth: parent.width - widget.categoryWidth
            contentHeight: grid.height

            Item {
                id: wrapper

                width: Math.max(parent.width - widget.categoryWidth, widget.width)
                height: Math.max(parent.height, grid.height)

                Grid {
                    id: grid

                    width: widget.width

                    Repeater {
                        id: repeater

                        objectName: "repeater"
                        model: widget.appModel

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
                            onClicked: widget.launch(Exec)
                        }

                    }

                }

            }

        }

    }

}
