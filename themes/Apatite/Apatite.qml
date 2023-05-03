// Copyright (C) 2022 smr.
// SPDX-License-Identifier: LGPL-3.0-only
// http://s-m-r.ir
pragma Singleton

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15
import QtQuick.Templates 2.15 as T
import org.kde.kirigami 2.15 as Kirigami

QtObject {
    function blend(color1, color2) {
        return Qt.rgba((color1.r + color2.r) / 2, (color1.g + color2.g) / 2,
                       (color1.b + color2.b) / 2, (color1.a + color2.a) / 2)
    }

    function pblend(color1, color2, p) {
        return Qt.rgba(
                    color1.r * p + color2.r * (1 - p), color1.g * p + color2.g * (1 - p),
                    color1.b * p + color2.b * (1 - p), color1.a * p + color2.a * (1 - p))
    }

    function setAlpha(color, alpha) {
        return Qt.rgba(color.r, color.g, color.b, alpha)
    }

    function clamp(x, a, b) {
        return Math.min(Math.max(x, a), b)
    }

    function remap(value, low1, high1, low2, high2) {
        return low2 + (high2 - low2) * (value - low1) / (high1 - low1)
    }

    function invertColor(color) {
        return Qt.rgba(1.0 - color.r, 1.0 - color.g, 1.0 - color.b, 1.0)
    }
}
