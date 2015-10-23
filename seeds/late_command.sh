#!/bin/sh
#
# Part of Sphaebian
#
# See LICENSE file for copyright and license details
#
# Many snippets kindly borrowed from Raspbian's Spindle

set -ex

modify_etc_skel() {
  sed /etc/skel/.bashrc -i 's/#force_color_prompt=yes/force_color_prompt=yes/'
}

setup_automounting() {
  onvm_chroot sh -l -e <<\EOF1
cat <<EOF2 > /etc/polkit-1/localauthority/50-local.d/55-storage.pkla
[Storage Permissions]
Identity=unix-group:plugdev
Action=org.freedesktop.udisks.filesystem-mount;org.freedesktop.udisks.drive-eject;org.freedesktop.udisks.drive-detach;org.freedesktop.udisks.luks-unlock;org.freedesktop.udisks.inhibit-polling;org.freedesktop.udisks.drive-set-spindown
ResultAny=yes
ResultActive=yes
ResultInactive=no
EOF2
}

add_pi_user_to_groups() {
  groupadd -f -r input
  groupadd -f -r spi
  groupadd -f -r i2c
  groupadd -f -r gpio
  for GRP in adm dialout cdrom audio users sudo video games plugdev input gpio spi i2c; do
    adduser pi $GRP
  done
}

configure_ifplugd() {
  sed /etc/default/ifplugd -i -e 's/^INTERFACES.*/INTERFACES="auto"/'
  sed /etc/default/ifplugd -i -e 's/^HOTPLUG_INTERFACES.*/HOTPLUG_INTERFACES="all"/'
}

setup_sudoers() {
  chmod +w /etc/sudoers
  echo "pi ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
  chmod -w /etc/sudoers
}

# We use a swap file rather than a swap partition for greater flexibility
# Not yet though in Sphaebian, just here for future use?
setup_swap() {
  apt-get -y install dphys-swapfile
  echo "CONF_SWAPSIZE=100" > /etc/dphys-swapfile
}

# Spread the word about my favourite inputrc tweak (done :) )
tweak_inputrc() {
  cat <<\EOF2 >> /etc/inputrc
# mappings for up and down arrows search history
# "\e[B": history-search-forward
# "\e[A": history-search-backward
EOF2
}

# It's not to have the sbin dirs in $PATH as that gives us ifconfig
fiddle_default_PATH() {
  # This sed match is clearly brittle and specific to the current debian 
  # /etc/profile
  sed /etc/profile -i -e \
    's|PATH="/usr/.*games.*$|PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/games:/usr/games"|'
  # need to fix ENV_PATH in /etc/login.defs
  sed -i /etc/login.defs -e "s|^ENV_PATH.*|ENV_PATH        PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/games:/usr/games|"
}

# Not using, don't know if needed?
configure_sound() {
  cat <<\EOF1 > /etc/asound.conf
pcm.mmap0 {
    type mmap_emul;
    slave {
      pcm "hw:0,0";
    }
}
pcm.!default {
  type plug;
  slave {
    pcm mmap0;
  }
}
EOF1
}

modify_etc_skel
#setup_automounting
add_pi_user_to_groups
configure_ifplugd
setup_sudoers
#setup_swap
tweak_inputrc
fiddle_default_PATH
#configure_sound
