#!/bin/bash

# Specify the path to the text file
file_path="/usr/share/applications/org.telegram.desktop.desktop"

# Specify the line you want to replace and the new line
old_line="Exec=telegram-desktop -- %u"
new_line="Exec=env QT_QPA_PLATFORM=xcb telegram-desktop -- %u"

# Use sed command to replace the line in the file
sed -i "s/$old_line/$new_line/g" "$file_path"
