import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.14
import org.kde.kirigami 2.15 as Kirigami
import Apatite 1.0

Item {
    Layout.minimumWidth: 200
    Layout.fillWidth: true
    height: parent.height
    Button {
        width: 200
        height: 200
        text: "I'm launcher"
    }
}
