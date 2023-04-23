# -*- coding: utf-8 -*-
import sys
from PySide2.QtGui import QGuiApplication, QScreen
from PySide2.QtQuick import QQuickItem, QQuickWindow
from PySide2.QtQml import QQmlApplicationEngine, QQmlComponent
from PySide2.QtCore import QUrl, QObject

from Xlib.display import Display
from Xlib import Xatom, X, protocol


class Widget:
    def __init__(self) -> None:
        self.obj = QObject()
        self.component = QQmlComponent

    def create(self, engine, props, app, parent=None):
        self.component = QQmlComponent(engine, QUrl("plugins/panel/panel.qml"))
        if not self.component.isReady():
            for error in self.component.errors():
                print(error.toString())
        self.obj = self.component.create()

        screen = app.primaryScreen()
        # set properties
        length = props["length"] if "length" in props else 100
        size = props["size"] if "size" in props else 24
        direction = props["direction"] if "direction" in props else 0
        vertical = True if direction == 2 or direction == 3 else False
        allocate_space = props["allocate-space"] if "allocate-space" in props else False

        # create strut
        display = Display()
        root = display.screen(0)['root']
        window = display.create_resource_object(
            "window", self.obj.winId())
        if allocate_space:
            strut = (0, 0, 0, size) if direction == 0 else (0, 0, size, 0) if direction == 1 else (
                size, 0, 0, 0) if direction == 2 else (0, size, 0, 0) if direction == 3 else (0, 0, 0, 0)
            window.change_property(display.get_atom(
                "_NET_WM_STRUT"), Xatom.CARDINAL, 32, strut, X.PropModeReplace)
        window.change_property(display.get_atom("_NET_WM_STATE"), Xatom.ATOM, 32, [
                               display.get_atom("_NET_WM_STATE_SKIP_TASKBAR")], X.PropModeAppend)
        window.change_property(display.get_atom("_NET_WM_STATE"), Xatom.ATOM, 32, [
                               display.get_atom("_NET_WM_STATE_SKIP_PAGER")], X.PropModeAppend)
        window.change_property(display.get_atom("_NET_WM_STATE"), Xatom.ATOM, 32, [
                               display.get_atom("_NET_WM_STATE_SKIP_SWITCHER")], X.PropModeAppend)
        window.change_property(display.get_atom(
            "_NET_WM_WINDOW_TYPE"), Xatom.ATOM, 32, [display.get_atom("_NET_WM_WINDOW_TYPE_DOCK")], X.PropModePrepend)
        desktop_request = protocol.event.ClientMessage(
            window=window, client_type=display.get_atom("_NET_WM_DESKTOP"), data=(32, [0xFFFFFFFF, 0, 0, 0, 0]))
        root.send_event(desktop_request, X.SubstructureNotifyMask)

        y = 0 if direction == 1 or direction == 2 or direction == 3 else screen.geometry().height() - \
            size
        x = 0 if direction == 0 or direction == 1 or direction == 2 else screen.geometry().width() - \
            size
        if direction == 0 or direction == 1:
            self.obj.setProperty(
                "width",  length / 100 * screen.geometry().width())
            self.obj.setProperty(
                "height",  size)
        else:
            self.obj.setProperty(
                "width",  size)
            self.obj.setProperty(
                "height",  length / 100 * screen.geometry().width())
        self.obj.setProperty("x", x)
        self.obj.setProperty("y", y)
        self.obj.setProperty("vertical", vertical)

        return 0
