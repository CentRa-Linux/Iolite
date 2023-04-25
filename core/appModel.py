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
    Signal,
    Slot,
)
from PySide2.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine

import core.appManager

paths = [
    "/usr/share/applications",
    "/usr/local/share/applications",
    os.path.expanduser("~/.local/share/applications"),
]


class AppModel(QAbstractListModel):
    NameRole = Qt.UserRole + 1
    IconRole = Qt.UserRole + 2
    ExecRole = Qt.UserRole + 3
    CommentRole = Qt.UserRole + 4
    HiddenRole = Qt.UserRole + 5
    NoDisplayRole = Qt.UserRole + 6

    count = 0

    def roleNames(self):
        return {
            Qt.UserRole + 1: b"Name",
            Qt.UserRole + 2: b"Icon",
            Qt.UserRole + 3: b"Exec",
            Qt.UserRole + 4: b"Comment",
            Qt.UserRole + 5: b"Hidden",
            Qt.UserRole + 6: b"NoDisplay",
        }

    apps = {}
    instance = core.appManager.appManager()

    def reload(self):
        self.apps = self.instance.apps
        self.count = len(self.apps)

    def added(self, index):
        self.beginInsertRows(QModelIndex(), index, index)
        self.apps = self.instance.apps
        self.count = len(self.apps)
        self.endInsertRows()

    def deleted(self, index):
        self.beginRemoveRows(QModelIndex(), index, index)
        self.apps = self.instance.apps
        self.count = len(self.apps)
        self.endRemoveRows()

    def modified(self, index):
        self.apps = self.instance.apps
        self.count = len(self.apps)
        self.dataChanged.emit(index, index)

    def __init__(self, parent=QObject | None) -> None:
        super().__init__()
        self.instance.message.onRescan.connect(self.reload, Qt.QueuedConnection)
        self.instance.message.onAdded.connect(self.added, Qt.QueuedConnection)
        self.instance.message.onModified.connect(self.modified, Qt.QueuedConnection)
        self.instance.message.onDeleted.connect(self.deleted, Qt.QueuedConnection)
        self.instance.start(paths)
        self.apps = self.instance.apps
        self.count = len(self.apps)
        print(self.index(0, 2))

    def index(self, row, column, parent=QModelIndex()):
        return self.createIndex(row, column, None)

    def data(self, index, role: int):
        row = index.row()
        match role:
            case self.NameRole:
                return list(self.apps.values())[row][0]["Name"]
            case self.IconRole:
                return (
                    list(self.apps.values())[row][0]["Icon"]
                    if "Icon" in list(self.apps.values())[row][0]
                    else ""
                )
            case self.ExecRole:
                return (
                    list(self.apps.values())[row][0]["Exec"]
                    if "Exec" in list(self.apps.values())[row][0]
                    else ""
                )
            case self.CommentRole:
                return (
                    list(self.apps.values())[row][0]["Comment"]
                    if "Comment" in list(self.apps.values())[row][0]
                    else ""
                )
            case self.HiddenRole:
                if "Hidden" not in list(self.apps.values())[row][0]:
                    return False
                else:
                    return (
                        True
                        if list(self.apps.values())[row][0]["Hidden"] == "true"
                        else False
                    )
            case self.NoDisplayRole:
                if "NoDisplay" not in list(self.apps.values())[row][0]:
                    return False
                else:
                    return (
                        True
                        if list(self.apps.values())[row][0]["NoDisplay"] == "true"
                        else False
                    )

    def rowCount(self, index):
        return len(self.apps)

    def columnCount(self, index):
        return 1

    @Slot(int, result="QVariant")
    def get(self, row):
        return list(self.apps.values())[row][0]
