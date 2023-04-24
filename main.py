# -*- coding: utf-8 -*-
import os
import sys
import importlib
import yaml
import signal
from PySide2.QtGui import QGuiApplication
from PySide2.QtQuick import QQuickItem
from PySide2.QtQml import QQmlApplicationEngine, QQmlEngine
from PySide2.QtCore import QUrl, QObject


def construct(input, engine, app, instances, parent=None, container_name=""):
    if "name" not in input:
        print("Error: you can't make widget without name")
        sys.exit(1)
    if input["name"] == "":
        print("Error: you can't make widget with empty name")
        sys.exit(1)

    props = {}
    for prop in input.items():
        if prop[0] != "name" and prop[0] != "container-names":
            if "container-names" in input:
                if prop[0] not in input["container-names"]:
                    props[prop[0]] = prop[1]
            else:
                props[prop[0]] = prop[1]
    print(props)

    module = importlib.import_module("plugins." + input["name"] + ".widget")
    instance = module.Widget()
    if parent != None:
        instance.create(
            engine, props, app, parent.obj.findChild(QObject, container_name)
        )
        instance.obj.setParent(parent.obj.findChild(QObject, container_name))
        parent.obj.findChild(QObject, container_name).children().append(instance.obj)
    else:
        instance.create(engine, props, app)
    instances.append(instance)

    if "container-names" in input:
        print("container widget:" + input["name"] + " container_name:" + container_name)
        for containername in input["container-names"]:
            if containername in input:
                for widget in input[containername]:
                    instances = construct(
                        widget,
                        engine,
                        app,
                        instances,
                        instance,
                        container_name=containername,
                    )
            else:
                print("Error: container doesn't exist despite container name declared!")
                sys.exit(1)
    else:
        print(
            "non-container widget:"
            + input["name"]
            + " container_name:"
            + container_name
        )
    return instances


if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    engine.addImportPath("themes")
    instances = []
    try:
        with open(sys.argv[1]) as file:
            input = yaml.safe_load(file)
            for widget in input["widgets"]:
                instances = construct(widget, engine, app, instances)
        signal.signal(signal.SIGINT, signal.SIG_DFL)
        sys.exit(app.exec_())
    except Exception as e:
        print("Exception occured while loading YAML:", file=sys.stderr)
        print(e, file=sys.stderr)
        sys.exit(1)
