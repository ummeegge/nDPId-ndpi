# nDPId Addon for IPFire

## About nDPId Addon for IPFire

This repository contains the build files for an IPFire based LFS system to build [nDPId](https://github.com/utoni/nDPId), nDPIsrvd and [nDPI](https://github.com/ntop/nDPI). The build files are structured closely like in the [IPFire development section](https://www.ipfire.org/docs/devel/ipfire-2-x/build-howto)) for building Addons explained.
This addon should enhances IPFire's network monitoring and security capabilities by integrating nDPId, nDPIsrvd, and nDPI. It provides deep packet inspection and protocol recognition, allowing for more granular network traffic analysis and control.


## Integration into the IPFire build environment

So the CONF directory contains the configuration file.
The LFS directory the building instructions.
The PAKS directory the installation, uninstallation and update scripts.
The initscripts directory contains the init script to start the whole nDPId process.
The ROOTFILE directory the installed files (lines without '#').

Key features of this addon include:

- Custom init script to manage the whole process od nDPId (/etc/init.d/nDPId).
- Dedicated system users and groups (ndpid, ndpisrvd, ndpi) for enhanced security.
- Automatic configuration during installation via install.sh script.
- Optimized for IPFire's ecosystem.
- Real-time network traffic analysis and classification.
- Integration with IPFire's logging and system (monitoring will come too).
- Custom UNIX socket communication (/run/nDPIsrvd/collector and /run/nDPIsrvd/distributor)

The addon uses dedicated system users and groups (ndpid, ndpisrvd, ndpi) for enhanced security. These are automatically configured during installation via the install.sh script.

nDPIsrvd acts as an intermediary, retrieving JSON messages from the collector socket and distributing them to higher-level applications or custom scripts for further analysis.

This addon should specifically tailored for seamless integration with IPFire, enhancing its network monitoring and security capabilities. It's designed to work efficiently within the IPFire ecosystem, providing insights into network traffic patterns and potential security threats.

## Resource Usage

In a typical configuration with one monitored interface, the addon's resource consumption in idle state is relatively modest:

```bash
Process: nDPIsrvd
RSS: round about 2 MiB
VMS: round about 3 MiB
CPU: <1%
Process: nDPId
RSS: round about 117 MiB
VMS: round about 804 MiB
CPU: ~1%
```

Note: Actual resource usage may vary depending on network traffic volume, system configuration, and load. These values represent the idle state and may increase with active network traffic.

## Building and Installing the Add-on

- After placing all files in the appropriate build environment sections, you need to extend the make.sh file. Since nDPId and nDPI should be build, you need to add them via 'lfsmake2' entry. So it should looks liek this

```bash
--- a/make.sh
+++ b/make.sh
@@ -2086,6 +2086,8 @@ build_system() {
        lfsmake2 btrfs-progs
        lfsmake2 inotify-tools
        lfsmake2 grub-btrfs
+       lfsmake2 nDPI
+       lfsmake2 nDPId
 
        lfsmake2 linux
        lfsmake2 rtl8812au
```

. After the comilation process is finished, you should find the ipfire packages under 

```bash
╰─➤  ll ipfire-2.x/images_x86_64/packages/nDPI*
-rw-r--r-- 1 root root 750K  5. Feb 12:32 ipfire-2.x/images_x86_64/packages/nDPI-4.13_dev-1.ipfire
-rw-r--r-- 1 root root 240K  5. Feb 12:32 ipfire-2.x/images_x86_64/packages/nDPId-1.7.1_dev-1.ipfire
```
. On your IPFire testingmachine you move this packages then to '/opt/pakfire/tmp' unpack and install them with
```bash
tar xvf {PACKAGENAME}
# Installtion
./install.sh
# Or uninstallation
./uninstall.sh
# Or to update them
./update.sh
```

## Configuration

To configure the nDPId and nDPIsrvd daemons:

1. Navigate to the `/etc/nDPId` directory and review the configuration files there.

2. Adjust these configuration files according to your specific requirements.

After making any changes to the configuration files, restart the nDPId service to apply the changes:

`/etc/init.d/nDPId restart`


This will ensure that the daemons are running with your updated configurations.

The default settngs are listening on the green0 interface and two running UNIX sockets under
```bash
$ ll /run/nDPIsrvd            
total 0
srw-rw---- 1 ndpisrvd ndpi 0 Feb 10 19:02 collector
srw-rw---- 1 ndpisrvd ndpi 0 Feb 10 19:02 distributor
```
.

### nDPI Configuration Files

Apart from that, the other nDPId/nDPIsrvd configuration settings has been left in the default configuration. There are two additional configuration files for advanced protocol recognition, which are delivered via nDPI:

1. ndpiCustomCategory.txt:
   - Allows defining custom protocols and categories
   - Enables creation of custom rules for protocol detection
   - Uses nBPF filters to categorize specific network traffic

2. ndpiProtos.txt (or protos.txt):
   - Configures custom protocols and sub-protocols
   - Enables port-based protocol detection
   - Allows defining sub-protocols based on string matching
   - Supports protocol definition for specific IP addresses and ports

Both files allow customization of nDPI's protocol recognition without modifying the source code, providing greater adaptability for specific network environments and requirements.


## Usage

After installation, the nDPId service will start automatically and should deliver somthing like this in process state:

```bash
$ ps aux | grep 'nDPI*' | grep -v grep
ndpisrvd 10982  0.0  0.1   3112  2176 ?        S    Feb10   0:51 /usr/bin/nDPIsrvd -f /etc/nDPId/nDPIsrvd.conf -L /var/log/nDPId/ndpisrvd.log
ndpid    11000  0.9  6.3 862556 127188 ?       Sl   Feb10  24:24 /usr/sbin/nDPId -f /etc/nDPId/nDPId.conf -L /var/log/nDPId/ndpid.log
```


You can monitor its status and control it using:
```bash
$ /etc/init.d/nDPId             
Usage: /etc/init.d/nDPId {start|stop|restart|status}
```

## Acknowledgments


This project builds upon and extends the work of:
- [nDPId and nDPIsrvd](https://github.com/utoni/nDPId)
- [nDPI](https://github.com/ntop/nDPI)

Special thanks to the IPFire team and community for providing a robust firewall platform that makes projects like this possible.

Contributions are welcome! Feel free to fork this repository and submit pull requests.



## License

This project is licensed under the GNU General Public License v3.0 (GPLv3). For more details, see the LICENSE file in this repository or visit https://www.gnu.org/licenses/gpl-3.0.html.


