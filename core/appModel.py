from __future__ import annotations

import os
import sys
import typing
from dataclasses import dataclass, fields
from pathlib import Path

from PySide6.QtCore import (
    QAbstractListModel,
    QByteArray,
    QCoreApplication,
    QModelIndex,
    QObject,
    Qt,
    QUrl,
)
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

import appManager

paths = ["/usr/share/applications", "/usr/local/share/applications", os.path.expanduser("~/.local/share/applications")]

class AppModel(QAbstractListModel):
    NameRole = Qt.UserRole + 1

    apps = {}
    instance = appManager()

    def __init__(self, parent=QObject | None) -> None:
        super().__init__()
        self.instance.start(paths)
        self.apps = instance.apps

    def data(self, index, role: int):


