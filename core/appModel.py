from __future__ import annotations

import os
import sys
import typing
import xml.etree.ElementTree as ET
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


def normalize(categories):
    resultCategories = categories
    for category in categories:
        if category in [
            "Network",
            "Email",
            "Dialup",
            "InstantMessaging",
            "Chat",
            "IRCClient",
            "Feed",
            "FileTransfer",
            "HamRadio",
            "News",
            "P2P",
            "RemoteAccess",
            "Telephony",
            "TelephonyTools",
            "VideoConference",
            "WebBrowser",
        ]:
            resultCategories.append("Internet")
        elif category in [
            "Game",
            "ActionGame",
            "AdventureGame",
            "ArcadeGame",
            "BoardGame",
            "BlocksGame",
            "CardGame",
            "KidsGame",
            "LogicGame",
            "RolePlaying",
            "Shooter",
            "Simulation",
            "SportsGame",
            "StrategyGame",
            "Sports",
            "Amusement",
        ]:
            resultCategories.append("Games")
        elif category in [
            "Utility",
            "TextTool",
            "TextTools",
            "Archiving",
            "Compression",
            "FileTool",
            "FileTools",
            "Calculator",
            "Clock",
            "TextEditor",
        ]:
            resultCategories.extend("Accessories", "Utilities")
        elif category in [
            "Building",
            "Debugger",
            "IDE",
            "GUIDesigner",
            "Profiling",
            "RevisionControl",
            "Translation",
            "WebDevelopment",
            "ParallelComputing",
            "Database",
            "ArtificialIntelligence",
        ]:
            resultCategories.append("Development")
        elif category in [
            "Calendar",
            "ContactManagement",
            "Dictionary",
            "Chart",
            "Finance",
            "FlowChart",
            "PDA",
            "ProjectManagement",
            "Presentation",
            "Spreadsheet",
            "WordProcessor",
            "Publishing",
            "Viewer",
        ]:
            resultCategories.append("Office")
        elif category in [
            "2DGraphics",
            "VectorGraphics",
            "RasterGraphics",
            "3DGraphics",
            "Scanning",
            "OCR",
            "Photography",
            "ImageProcessing",
        ]:
            resultCategories.append("Graphics")
        elif category in [
            "AudioVideo",
            "Player",
            "Audio",
            "Video",
            "Midi",
            "Mixer",
            "Sequencer",
            "Tuner",
            "TV",
            "AudioVideoEditing",
            "Recorder",
            "DiscBurning",
            "Adult",
        ]:
            resultCategories.extend("Multimedia", "Sound & Video")
        elif category in [
            "Construction",
            "Astronomy",
            "Biology",
            "Chemistry",
            "ComputerScience",
            "DataVisualization",
            "Economy",
            "Electricity",
            "Geography",
            "Geology",
            "Geoscience",
            "Maps",
            "Math",
            "NumericalAnalysis",
            "MedicalSoftware",
            "Physics",
            "Robotics",
            "Electronics",
            "Engineering",
        ]:
            resultCategories.append("Science")
        elif category in [
            "Literature",
            "Art",
            "Languages",
            "History",
            "Humanities",
            "Spirituality",
        ]:
            resultCategories.extend("Education", "Science")
        elif category in [
            "Emulator",
            "FileManager",
            "TerminalEmulator",
            "Filesystem",
            "Monitor",
        ]:
            resultCategories.append("System")
        elif category in ["Settings", "Security", "Accessibility"]:
            resultCategories.append("Preferences")
    return set(resultCategories)


class AppModel(QAbstractListModel):
    NameRole = Qt.UserRole + 1
    IconRole = Qt.UserRole + 2
    ExecRole = Qt.UserRole + 3
    CommentRole = Qt.UserRole + 4
    HiddenRole = Qt.UserRole + 5
    NoDisplayRole = Qt.UserRole + 6
    TerminalRole = Qt.UserRole + 7
    CategoriesRole = Qt.UserRole + 8

    count = 0

    def roleNames(self):
        return {
            Qt.UserRole + 1: b"Name",
            Qt.UserRole + 2: b"Icon",
            Qt.UserRole + 3: b"Exec",
            Qt.UserRole + 4: b"Comment",
            Qt.UserRole + 5: b"Hidden",
            Qt.UserRole + 6: b"NoDisplay",
            Qt.UserRole + 7: b"Terminal",
            Qt.UserRole + 8: b"Categories",
        }

    apps = {}
    mainMenu = {}
    selectedCategory = ""
    instance = core.appManager.appManager()

    def loadCategory(self):
        tree = ET.parse("/etc/xdg/menus/nu-applications.menu")
        root = tree.getroot()

        for menu in root.findall("./Menu"):
            if menu.find("Directory") != None:
                directory = menu.find("Directory").text
                include = menu.find("Include")
                categories = include.findall(".//Category")
                notCategories = include.findall(".//Not/Category")

                categoryNames = [
                    category.text for category in set(categories) - set(notCategories)
                ]
                notCategoryNames = [category.text for category in notCategories]
                self.mainMenu[directory] = (categoryNames, notCategoryNames)

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
        self.loadCategory()
        self.instance.start(paths)
        self.apps = self.instance.apps
        self.count = len(self.apps)

    def index(self, row, column, parent=QModelIndex()):
        return self.createIndex(row, column, None)

    def data(self, index, role: int):
        row = index.row()
        if role == self.NameRole:
            return list(self.apps.values())[row][0]["Name"]
        elif role == self.IconRole:
            return (
                list(self.apps.values())[row][0]["Icon"]
                if "Icon" in list(self.apps.values())[row][0]
                else ""
            )
        elif role == self.ExecRole:
            return (
                list(self.apps.values())[row][0]["Exec"]
                if "Exec" in list(self.apps.values())[row][0]
                else ""
            )
        elif role == self.CommentRole:
            return (
                list(self.apps.values())[row][0]["Comment"]
                if "Comment" in list(self.apps.values())[row][0]
                else ""
            )
        elif role == self.HiddenRole:
            if "Hidden" not in list(self.apps.values())[row][0]:
                return False
            else:
                return (
                    True
                    if list(self.apps.values())[row][0]["Hidden"] == "true"
                    else False
                )
        elif role == self.NoDisplayRole:
            if "NoDisplay" not in list(self.apps.values())[row][0]:
                return False
            else:
                return (
                    True
                    if list(self.apps.values())[row][0]["NoDisplay"] == "true"
                    else False
                )
        elif role == self.TerminalRole:
            if "Terminal" not in list(self.apps.values())[row][0]:
                return False
            else:
                return (
                    True
                    if list(self.apps.values())[row][0]["Terminal"] == "true"
                    else False
                )
        elif role == self.CategoriesRole:
            if "Categories" not in list(self.apps.values())[row][0]:
                return []
            else:
                return normalize(
                    list(self.apps.values())[row][0]["Categories"].split(";")
                )

    def rowCount(self, index):
        return len(self.apps)

    def columnCount(self, index):
        return 1

    @Slot(int, result="QVariant")
    def get(self, row):
        return list(self.apps.values())[row][0]
