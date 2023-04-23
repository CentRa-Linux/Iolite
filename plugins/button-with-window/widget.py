# -*- coding: utf-8 -*-
import sys
import subprocess
from PySide2.QtGui import QGuiApplication, QScreen
from PySide2.QtQuick import QQuickItem, QQuickWindow
from PySide2.QtQml import QQmlApplicationEngine, QQmlComponent
from PySide2.QtCore import QUrl, QObject, QTimer

from Xlib.display import Display
from Xlib import Xatom, X, protocol


class Widget:
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
        self.obj = self.component.createWithInitialProperties(
            {"parent": parent, "iconname": iconname}
        ).findChild(QQuickWindow, "window")

        display = Display()
        root = display.screen(0)["root"]
        window = display.create_resource_object("window", self.obj.winId())
        window.change_property(
            display.get_atom("_NET_WM_STATE"),
            Xatom.ATOM,
            32,
            [display.get_atom("_NET_WM_STATE_SKIP_TASKBAR")],
            X.PropModeAppend,
        )
        window.change_property(
            display.get_atom("_NET_WM_STATE"),
            Xatom.ATOM,
            32,
            [display.get_atom("_NET_WM_STATE_SKIP_PAGER")],
            X.PropModeAppend,
        )
        window.change_property(
            display.get_atom("_NET_WM_STATE"),
            Xatom.ATOM,
            32,
            [display.get_atom("_NET_WM_STATE_SKIP_SWITCHER")],
            X.PropModeAppend,
        )
        desktop_request = protocol.event.ClientMessage(
            window=window,
            client_type=display.get_atom("_NET_WM_DESKTOP"),
            data=(32, [0xFFFFFFFF, 0, 0, 0, 0]),
        )
        root.send_event(desktop_request, X.SubstructureNotifyMask)

        self.app = app
        screen = self.app.primaryScreen()
        width = props["width"] if "width" in props else 300
        height = props["height"] if "height" in props else 300
        direction = props["direction"] if "direction" in props else 0
        animation = props["animation"] if "animation" in props else 0
        layoutType = props["layoutType"] if "layoutType" in props else 0
        self.obj.setProperty("availableGeometryX", screen.availableGeometry().x())
        self.obj.setProperty("availableGeometryY", screen.availableGeometry().y())
        screen.availableGeometryChanged.connect(self.availableGeometryChanged)
        self.obj.setProperty("width", width)
        self.obj.setProperty("height", height)
        self.obj.setProperty("direction", direction)
        self.obj.setProperty("animation", animation)
        self.obj.setProperty("layoutType", layoutType)

        return 0

    def availableGeometryChanged(self):
        screen = self.app.primaryScreen()
        self.obj.setProperty("availableGeometryX", screen.availableGeometry().x())
        self.obj.setProperty("availableGeometryY", screen.availableGeometry().y())
