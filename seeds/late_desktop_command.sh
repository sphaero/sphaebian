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
After=systemd-user-sessions.service
     
[Service]
ExecStart=/sbin/agetty --autologin pi --noclear tty8 38400
     
[Install]
WantedBy=multi-user.target
EOF
  systemctl enable x11-login.service
  if grep -q "/dev/tty8" /etc/bash.bashrc; then
     # return so we don't add to bashrc
     return
  fi
  # add to bashrc
  cat <<"EOF" >> /etc/bash.bashrc
if [[ ! ${DISPLAY} && `tty` == "/dev/tty8" ]]; then
    exec startx
fi
EOF
}

systemd_autologin
