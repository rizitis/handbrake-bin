#!/bin/bash

cd /opt/handbrake-bin || exit
bash ./libs/libhacker.sh
sleep 2

GDK_BACKEND=x11 GTK_USE_PORTAL=0 \
DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$UID/bus" \
LD_LIBRARY_PATH=./libs:$LD_LIBRARY_PATH ./ghb
