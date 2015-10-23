# Sphaebian

Debian Based Distro for people like me

This is just a normal Debian distro with many tweaks inspired by many other setups, amongst others:

* [Raspbian/Spindle](https://github.com/RPi-Distro/spindle)
* Multistrap
* Preseeding
* [Vmdebootstrap](http://git.liw.fi/cgi-bin/cgit/cgit.cgi/vmdebootstrap/tree/README) 
* [Emdebian](http://www.emdebian.org) RIP
* SteamOS

My ultimate goal is to have a full busybox based root filesystem but with Debian this is impossible currently. My second goal is to have a Debian based rootfs mimicking Raspbian as close as possible.

## Usage

To install this run the debian installer using favourite method (CD, PXE, etc). The run the following command to boot the debian installer

  install preseed/url=https://raw.githubusercontent.com/sphaero/sphaebian/master/seeds/sphaebian.seed

Or use the url shortener:

  install preseed/url=https://goo.gl/fzBNqt

## Tweaks

* some minor tweaks through preseeding the installer
  * no root account creation
  * pi user account creation (default pw)
  * enable all debian repository sections
  * add some essential packages (openssh-server console-setup keyboard-configuration debconf-utils less ifplugd ntp dbus ca-certificates)
  * set some debconf answers like locales
  * issue a post install command
  * remove quiet kernel boot
* post install command:
  * modify /etc/skel to have a color prompt
  * add some groups
  * configure ifplugd
  * setup sudoers
  * tweak inputrc (as done in Spindle)
  * add */sbin to PATH env
  * rename to Sphaebian


