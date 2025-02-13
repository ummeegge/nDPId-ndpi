#!/bin/bash
############################################################################
#                                                                          #
# This file is part of the IPFire Firewall.                                #
#                                                                          #
# IPFire is free software; you can redistribute it and/or modify           #
# it under the terms of the GNU General Public License as published by     #
# the Free Software Foundation; either version 2 of the License, or        #
# (at your option) any later version.                                      #
#                                                                          #
# IPFire is distributed in the hope that it will be useful,                #
# but WITHOUT ANY WARRANTY; without even the implied warranty of           #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            #
# GNU General Public License for more details.                             #
#                                                                          #
# You should have received a copy of the GNU General Public License        #
# along with IPFire; if not, write to the Free Software                    #
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA #
#                                                                          #
# Copyright (C) 2007 IPFire-Team <info@ipfire.org>.                        #
#                                                                          #
############################################################################
#
. /opt/pakfire/lib/functions.sh

NAME="nDPId"

# Stop Service if it is running
if pidof -x "${NAME}" >/dev/null; then
	/etc/init.d/nDPId stop;
fi

# Delete Files
rm -rfv \
/etc/nDPId \
/usr/bin/nDPId* \
/usr/bin/nDPIsrvd* \
/usr/sbin/nDPId \
/var/log/nDPId \
/var/ipfire/nDPId \
/opt/pakfire/db/installed/meta-${NAME}
echo "Have deleted files and directories... "
echo

# Delete Symlinks for init script
rm -rfv /etc/rc.d/rc?.d/???nDPId
echo "Have deleted initscript symlinks... "
echo

if grep -q "${NAME}" /etc/passwd; then
	userdel ndpid ndpisrvd
	groupdel ndpi
	echo "Have deleted group and users 'ndpi{d}{srvd}'... "
	echo
fi

echo
echo "Uninstallation is done... "
echo

# EOF
