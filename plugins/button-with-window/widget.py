# -*- coding: utf-8 -*-
import sys
import subprocess
import concurrent.futures
from PySide2.QtGui import QGuiApplication, QScreen
from PySide2.QtQuick import QQuickItem, QQuickWindow
from PySide2.QtQml import QQmlApplicationEngine, QQmlComponent
from PySide2.QtCore import QUrl, QObject, QTimer, Signal, Qt

from Xlib.display import Display
from Xlib import Xatom, X, protocol, Xutil, xobject


class Widget:
    lastwindow = 0

    def __init__(self) -> None:
        self.obj = QQuickItem()

    def create(self, engine, props, app, parent=None):
        self.component = QQmlComponent(
            engine, QUrl("plugins/button-with-window/button.qml")
        )
        if not self.component.isReady():
            for error in self.component.errors():
                print(error.toString())
        iconname = props["iconname"] if "iconname" in props else ""
        self.button = self.component.createWithInitialProperties(
            {"parent": parent, "iconname": iconname}
        )
        self.obj = self.button.findChild(QQuickWindow, "window")

        self.app = app
        screen = self.app.primaryScreen()
        width = props["width"] if "width" in props else 300
        height = props["height"] if "height" in props else 300
        direction = props["direction"] if "direction" in props else 0
        animation = props["animation"] if "animation" in props else 0
        layoutType = props["layoutType"] if "layoutType" in props else 0
        self.obj.setProperty("setting", True)
        self.obj.setProperty("availableGeometryX", screen.availableGeometry().x())
        self.obj.setProperty("availableGeometryY", screen.availableGeometry().y())
        self.obj.setProperty("width", width)
        self.obj.setProperty("height", height)
        self.obj.setProperty("direction", direction)
        self.obj.setProperty("animation", animation)
        self.obj.setProperty("layoutType", layoutType)

        display = Display()
        root = display.screen(0)["root"]
        window = display.create_resource_object("window", self.obj.winId())
        window.change_property(
            display.intern_atom("_NET_WM_WINDOW_TYPE"),
            Xatom.ATOM,
            32,
            [display.intern_atom("_NET_WM_WINDOW_TYPE_DOCK")],
            X.PropModeReplace,
        )
        display.flush()

        self.obj.visibleChanged.connect(self.show, Qt.QueuedConnection)
        self.show()

        self.lastwindow = self.obj.winId()
        pool = concurrent.futures.ThreadPoolExecutor()
        pool.submit(self.observeActiveWindow)

        return 0

    def show(self):
        if self.obj.isVisible() == False:
            return
        display = Display()
        root = display.screen(0)["root"]
        window = display.create_resource_object("window", self.obj.winId())

        # Needed to get frameless window
        value = b"\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"

        window.change_property(
            display.intern_atom("_MOTIF_WM_HINTS"),
            display.intern_atom("_MOTIF_WM_HINTS"),
            32,
            value,
            X.PropModeReplace,
            onerror=None,
        )
        display.flush()

        window.change_property(
            display.intern_atom("_NET_WM_STATE"),
            Xatom.ATOM,
            32,
            [display.intern_atom("_NET_WM_STATE_ABOVE")],
            X.PropModeReplace,
        )
        window.change_property(
            display.intern_atom("_NET_WM_STATE"),
            Xatom.ATOM,
            32,
            [display.intern_atom("_NET_WM_STATE_FOCUSED")],
            X.PropModeAppend,
        )
        window.change_property(
            display.intern_atom("_NET_WM_STATE"),
            Xatom.ATOM,
            32,
            [display.intern_atom("_NET_WM_STATE_SKIP_TASKBAR")],
            X.PropModeAppend,
        )
        display.flush()
        window.change_property(
            display.intern_atom("_NET_WM_STATE"),
            Xatom.ATOM,
            32,
            [display.intern_atom("_NET_WM_STATE_SKIP_PAGER")],
            X.PropModeAppend,
        )
        display.flush()

    def hide(self):
        self.button.setProperty("checked", False)

    def activeWindowChanged(self, event):
        if event.type != X.PropertyNotify:
            return
        display = Display()
        root = display.screen(0)["root"]
        if event.atom == display.intern_atom("_NET_ACTIVE_WINDOW"):
            if (
                root.get_full_property(
                    display.intern_atom("_NET_ACTIVE_WINDOW"), Xatom.WINDOW
                ).value[0]
                != self.obj.winId()
                and self.lastwindow
                != root.get_full_property(
                    display.intern_atom("_NET_ACTIVE_WINDOW"), Xatom.WINDOW
                ).value[0]
            ):
                self.button.setProperty("checked", False)
            self.lastwindow = root.get_full_property(
                display.intern_atom("_NET_ACTIVE_WINDOW"), Xatom.WINDOW
            ).value[0]

    def observeActiveWindow(self):
        display = Display()
        root = display.screen(0).root
        root.change_attributes(event_mask=X.PropertyChangeMask)
        while True:
            self.activeWindowChanged(display.next_event())

    def availableGeometryChanged(self):
        screen = self.app.primaryScreen()
        self.obj.setProperty("availableGeometryX", screen.availableGeometry().x())
        self.obj.setProperty("availableGeometryY", screen.availableGeometry().y())
