import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.14
import org.kde.kirigami 2.15 as Kirigami

Window {
    id: window
    objectName: "window"
    //flags: Qt.CustomizeWindowHint | Qt.WindowDoesNotAcceptFocus | Qt.WindowStaysOnTopHint | Qt.FramelessWindowHint
    flags: Qt.WindowDoesNotAcceptFocus | Qt.WindowStaysOnTopHint | Qt.WindowStaysOnTopHint | Qt.FramelessWindowHint

    property bool vertical: false

    x: 0
    y: 0

    height: 200
    width: 500

    title: qsTr("Panel")
    visible: true

    color: Kirigami.Theme.backgroundColor

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
