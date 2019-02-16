#!/bin/bash

mount --bind /tmp /mnt/HD/HD_a2/Nas_Prog/Debian/chroot/mnt/tmp

checkincomplete=`find </local/nas/folder> -type f -name "*lftp-pget-status"`

if [ "$checkincomplete" != "" ]

then

resumefile=`basename "$checkincomplete" .lftp-pget-status | sed 's/\s/\\\ /g'`

resumepath=`dirname "$checkincomplete" | sed 's/\/HD\/HD_a2/\/shares/g'`

prefix="</local/nas/folder>"

remotepath=${resumepath/#$prefix}

fi

freespacestr=`df -h | awk '$1=="/mnt/HD/HD_a2" {print $4}'`

freespace=`echo "${freespacestr%?}"`

freespace=`echo "${freespacestr:0:-3}"`

spacestr=`echo "${freespacestr: -1}"`

if [ "$spacestr" == "T" ] || [ "$freespace" -gt 30 ]

then

cat <<EOF | chroot /mnt/HD/HD_a2/Nas_Prog/Debian/chroot /bin/bash

trap "rm -f /mnt/tmp/synctorrent.lock" INT TERM

if [ -e /mnt/tmp/synctorrent.lock ]

then

exit 1

else 

touch /mnt/tmp/synctorrent.lock

cd $resumepath

lftp<<UPTOHERE

set cmd:status-interval 1s

set ftp:charset utf8

set ftp:ssl-force true

set ftp:ssl-protect-data true

set ftp:ssl-protect-list true

set mirror:parallel-directories false

set mirror:parallel-transfer-count 1

set mirror:parallel-directories false

set mirror:use-pget-n 10

set net:connection-limit 10 

set net:connection-takeover true

set net:limit-total-max 0

set net:limit-total-rate 0:0

set pget:min-chunk-size 100000000

set ssl:verify-certificate off

open -p <port> -u <username>,<password> <address>

set file:charset utf8

pget -c -n 10 </remote/ftp/folder>/$remotepath/$resumefile

glob -d mirror --newer-than=now-7days -c --loop --only-missing </remote/ftp/folder> <“/local/nas/folder”>

quit 0

UPTOHERE

rm -f /mnt/tmp/synctorrent.lock

trap - INT TERM

cd /

sh chroot-debian.sh stop

exit 0

fi

EOF

else

bash /mnt/HD/HD_a2/script/notify.sh “Sync cancelled (free some space on the nas!)“

fi