#!/bin/bash

killall picom
sleep 0.3

picom --config ~/.config/picom/picom.conf --experimental-backends --glx-no-rebind-pixmap --use-damage  --xrender-sync-fence
