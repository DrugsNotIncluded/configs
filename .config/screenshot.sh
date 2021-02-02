#!/bin/bash
now=$(date +'%s_screenshot.png')
grim $HOME/Screenshots/$now
notify-send $now
