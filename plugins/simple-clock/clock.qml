import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import org.kde.kirigami 2.15 as Kirigami

Item {
    id: root
    property string timedate
    width: 100
    height: parent.height

    Text {
        id: text
        color: Kirigami.Theme.textColor
        anchors.centerIn: parent
        text: root.timedate
    }
}
