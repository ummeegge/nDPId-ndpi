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

if pidof -x "nDPId" >/dev/null; then
    echo "nDPid is installed and already running"
fi

extract_files
restore_backup ${NAME}

# Formatting and Colors
COLUMNS="$(tput cols)";
R=$(tput setaf 1);
Y=$(tput setaf 3);
B=$(tput setaf 6);
N=$(tput sgr0);
seperator(){ printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -; };

# Create group ndpi if it does not exist
if ! getent group ndpi > /dev/null 2>&1; then
    groupadd ndpi
    echo "${Y}Have addded group 'ndpi' under /etc/group... ${N}"
    echo
fi

# Create user ndpid if it does not exist
if ! id -u ndpid > /dev/null 2>&1; then
    useradd -r -s /sbin/nologin -g ndpi ndpid
    echo "${Y}Have addded user 'ndpid' under /etc/passwd and have added him to group 'ndpi'... ${N}"
    echo
fi

# Create user ndpisrvd if it does not exist
if ! id -u ndpisrvd > /dev/null 2>&1; then
    useradd -r -s /sbin/nologin -g ndpi ndpisrvd
    echo "${Y}Have addded user 'ndpisrvd' under /etc/passwd and have added him to group 'ndpi'... ${N}"
    echo
fi

# Set ownership for /var/log/nDPId
chown root:ndpi /var/log/nDPId
chmod 750 /var/log/nDPId
echo "${Y}The log directory under /var/log/nDPId has been created and ownership has been set... ${N}"
echo

# Set ownership for /var/ipfire/nDPId
chown ndpid:ndpi /var/ipfire/nDPId
chmod 750 /var/ipfire/nDPId
echo "${Y}The nDPId home directory under /var/ipfire/nDPId has been created and ownership has been set... ${N}"
echo

# Set ownership for /etc/nDPId
chown root:ndpi /etc/nDPId
chmod 750 /etc/nDPId
echo "${Y}The nDPId configuration directory under /etc/nDPId has been created and ownership has been set... ${N}"
echo

# Set ownership for /usr/sbin/nDPId
chown root:ndpi /usr/sbin/nDPId
chmod 750 /usr/sbin/nDPId

# Set ownership for /usr/bin/nDPIsrvd
chown root:ndpi /usr/bin/nDPIsrvd
chmod 750 /usr/bin/nDPIsrvd
echo "${Y}Have installed the binaries under /usr/sbin/nDPId and /usr/bin/nDPIsrvd... ${N}"
echo

# Set symlinks for init script if not already done
if ! ls /etc/rc.d/rc?.d/???${NAME} >/dev/null 2>&1; then
    # Set symlinks for init script
    ln -s ../init.d/${NAME} /etc/rc.d/rc3.d/S20${NAME}
    ln -s ../init.d/${NAME} /etc/rc.d/rc0.d/K80${NAME}
    ln -s ../init.d/${NAME} /etc/rc.d/rc6.d/K80${NAME}
fi

# Add meta file for IPFire WUi status section
if ! ls /opt/pakfire/db/installed/ | grep -q "meta-${NAME}"; then
    touch /opt/pakfire/db/installed/meta-${NAME};
    echo "${Y}Have added now meta file for de- or activation via IPfire WUI ${NAME} on reboot... ${N}";
    echo;
    seperator;
else
    echo "${NAME} meta file has already been set, will do nothing... ";
    echo
fi

/etc/init.d/nDPId start

# EOF

