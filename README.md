You do it at your own risk, remember it.

# mycloud-ftp
Custom script based on Debian environment 

Why: create a sync script from a remote ftp over ssl source and a local folder as destination using lftp (https://lftp.yar.ru/). 
The built-in solution doesn't work for me.

Wd my cloud gen2 software is based on busybox, so we need a parallel environment and shell to install it and make it permanent.

I own a mirror gen2.

Begin - install the Debian chroot environment


1- download the chrooted debian app (credits for this app goes to Fox_exe)

2- set the chroot environment. on the mirror gen2 the path is /mnt/HD/HD_a2/Nas_Prog/Debian/chroot

3-lftp depends on some packages that are not available in the repository. 
i have grabbed them from these repository and installed manually using dpkg http://mwn-cdc.arsip.or.id/debian-security/pool/updates/main/b/bind9/

libdns-export100_9.9.5.dfsg-9+deb8u6_armhf, libirs-export91_9.9.5.dfsg-9+deb8u6_armhf, libisc-export95_9.9.5.dfsg-9+deb8u6_armhf, libisccfg-export90_9.9.5.dfsg-9+deb8u6_armhf


you can (finally!) install lftp via apt-get install

# the script

Some explanations first:

as stated, this is based on mirror gen2

don’t forget to chmod + x the .sh script file!

search in the wd community forum how to create a cron job. on my nas the script is launched every hour

- the script is launched only if you have at least 30gb of free space available
- synctorrent.lock is a simple file used to check wether there is already a download activity
- the script check the files/folders present in a remote ftp over ssl folder (last 7 days)
- segmented download, no parallel file download (i have encountered issues using it)
- notify.sh was a script related to an android app (push notification)

known issues: synctorrent.lock sometimes is still on the nas, even if no download activity is on the go (e.g. power interruption)
