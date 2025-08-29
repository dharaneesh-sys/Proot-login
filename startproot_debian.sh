#!/bin/bash
killall -9 termux-x11 Xwayland pulseaudio virgl_test_server_android termux-wake-lock

termux-toast "Starting X11"
am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity
XDG_RUNTIME_DIR=${TMPDIR}
termux-x11 :0 -ac &
sleep 3

pulseaudio --start --load="module-native-protocol-tcp auth-ip acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1
pacmd load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1

MESA_NO_ERROR=1
GALLIUM_DRIVER=virpipe MESA_GL_VERSION_OVERRIDE=4.6COMPAT MESA_GLES_VERSION_OVERRIDE=3.2

virgl_test_server_android &

proot-distro login debian --user dinusus --shared-tmp --no-sysvipc --bind /dev/null:/proc/sys/kernel/cap_last_cap -- bash -c "export DISPLAY=:0 GALLIUM_DRIVER=virpipe MESA_GL_VERSION_OVERRIDE=4.6COMPAT MESA_GLES_VERSION_OVERRIDE=3.2 PULSE_SERVER=tcp:127.0.0.1; dbus-launch --exit-with-session startxfce4"

exit
