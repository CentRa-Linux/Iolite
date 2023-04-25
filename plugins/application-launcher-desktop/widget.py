# -*- coding: utf-8 -*-
import sys
import subprocess
import core.appModel
from PySide2.QtGui import QGuiApplication
from PySide2.QtQuick import QQuickItem
from PySide2.QtQml import QQmlApplicationEngine, QQmlComponent
from PySide2.QtCore import QUrl, QObject, QTimer, QModelIndex, Qt


class Widget:
    AppModel = core.appModel.AppModel()

    def __init__(self) -> None:
        self.obj = QQuickItem()

    def create(self, engine, props, app, parent=None):
        self.component = QQmlComponent(
            engine, QUrl("plugins/application-launcher-desktop/widget.qml")
        )
        if not self.component.isReady():
            for error in self.component.errors():
                print(error.toString())
        self.obj = self.component.createWithInitialProperties(
            {"parent": parent, "appModel": self.AppModel}
        )

        return 0
