#!/bin/bash

killall picom
sleep 0.3

picom --config ~/.config/picom.conf 
