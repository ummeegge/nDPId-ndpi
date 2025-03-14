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
extract_files

# Check if ndpi group exists, if not create it
if ! getent group ndpi > /dev/null 2>&1; then
    groupadd ndpi
fi

# Set permissions for nDPI files
chown root:ndpi /usr/share/ndpi/ndpiCustomCategory.txt /usr/share/ndpi/ndpiProtos.txt
chmod 644 /usr/share/ndpi/ndpiCustomCategory.txt /usr/share/ndpi/ndpiProtos.txt

# Set permissions for nDPI library files
chown root:ndpi /usr/lib/libndpi.so*
chmod 755 /usr/lib/libndpi.so*

# use ldconfig to integrate library
ldconfig

# EOF

