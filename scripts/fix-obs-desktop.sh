#!/bin/bash

# Specify the path to the text file
file_path="/usr/share/applications/com.obsproject.Studio.desktop"

# Specify the line you want to replace and the new line
old_line="Exec=obs"
new_line="Exec=env QT_QPA_PLATFORM=xcb QT_QPA_PLATFORMTHEME=gtk3 obs"

# Use sed command to replace the line in the file
sed -i "s/$old_line/$new_line/g" "$file_path"
