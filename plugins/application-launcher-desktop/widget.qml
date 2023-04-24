import Apatite 1.0
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.14
import org.kde.kirigami 2.15 as Kirigami

Item {
    property var appModel

    Layout.minimumWidth: 200
    Layout.fillWidth: true
    height: parent.height

    Repeater {
        id: repeater

        objectName: "repeater"
        model: appModel

        Text {
            y: index * 20
            text: name
        }

    }

}
