TEMPLATE = lib
QT += qml quick quickcontrols2
CONFIG += qt plugin

include(Apatite.pri)

qmltypes.target = qmltypes
qmltypes.commands = $$[QT_INSTALL_BINS]/qmlplugindump Apatite 1.0 $$QMAKE_RESOLVED_TARGET > $$PWD/apatite.qmltypes
qmltypes.depends = $$QMAKE_RESOLVED_TARGET

QMAKE_EXTRA_TARGETS += qmltypes
