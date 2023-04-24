from __future__ import annotations

import os
import sys
import typing
from dataclasses import dataclass, fields
from pathlib import Path

from PySide2.QtCore import (
    QAbstractListModel,
    QByteArray,
    QCoreApplication,
    QModelIndex,
    QObject,
    Qt,
    QUrl,
)
from PySide2.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine

import core.appManager

paths = ["/usr/share/applications", "/usr/local/share/applications", os.path.expanduser("~/.local/share/applications")]

class AppModel(QAbstractListModel):
    NameRole = Qt.UserRole + 1
    IconRole = Qt.UserRole + 2
    CommentRole = Qt.UserRole + 3

    def roleNames(self):
        return {
            Qt.UserRole + 1: b'name',
            Qt.UserRole + 2: b'icon',
            Qt.UserRole + 3: b'comment'
        }

    apps = {}
    instance = core.appManager.appManager()

    def reload(self):
        self.apps = instance.apps

    def __init__(self, parent=QObject | None) -> None:
        super().__init__()
        self.instance.onRescan = self.reload
        self.instance.start(paths)
        self.apps = self.instance.apps

    def index(self, row, column, parent=QModelIndex()):
        return self.createIndex(row, column, None)

    def data(self, index, role: int):
        row = index.row()
        match role:
            case self.NameRole:
                return list(self.apps.values())[row][0]["Name"]
            case self.IconRole:
                return list(self.apps.values())[row][0]["Icon"]
            case self.CommentRole:
                return list(self.apps.values())[row][0]["Comment"]

    def rowCount(self, index):
        return len(self.apps)

    def columnCount(self, index):
        return 1
