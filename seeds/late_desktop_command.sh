#!/bin/sh
#
# Part of Sphaebian
#
# See LICENSE file for copyright and license details
#
# Many snippets kindly borrowed from Raspbian's Spindle

set -ex

systemd_autologin() {
  cat <<EOF> /etc/systemd/system/x11-login.service
[Unit]
Description=Autologin getty on tty8
After=systemd-user-sessions.service plymouth-quit-wait.service
After=rc-local.service

Before=getty.target
IgnoreOnIsolate=yes

ConditionPathExists=/dev/tty8

[Service]
ExecStart=/sbin/agetty --autologin pi --noclear tty8 38400
Type=idle
UtmpIdentifier=tty8
TTYPath=/dev/tty8
TTYReset=yes
TTYVHangup=yes
TTYVTDisallocate=yes
KillMode=process
IgnoreSIGPIPE=no
SendSIGHUP=yes

[Install]
WantedBy=multi-user.target
DefaultInstance=tty8
EOF
  systemctl enable x11-login.service
  if grep -q "/dev/tty8" /etc/bash.bashrc; then
     # return so we don't add to bashrc
     return
  fi
  # add to bashrc
  cat <<"EOF" >> /etc/profile
if [[ ! ${DISPLAY} && `tty` == "/dev/tty8" ]]; then
    exec startx
fi
EOF
}

# skipping for now! systemd_autologin
#copy i3 config
wget -q https://raw.githubusercontent.com/sphaero/sphaebian/master/config/i3/config -O /etc/i3/config
