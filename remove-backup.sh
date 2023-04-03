#!/bin/bash

find ./ -type f -name "*.qml~" | xargs rm
echo "ok"
