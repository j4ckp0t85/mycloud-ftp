#!/bin/bash

freespacestr=df -h | awk '$1=="/mnt/HD/HD_a2" {print $4}'

freespace=echo "${freespacestr%?}"

freespace=echo "${freespacestr:0:-3}"

spacestr=echo "${freespacestr: -1}"

if [ “$spacestr” == “T” ] || [ “$freespace” -gt 30 ]

then

cat <<EOF | chroot /mnt/HD/HD_a2/Nas_Prog/Debian/chroot /bin/bash

trap “rm -f /tmp/synctorrent.lock” INT TERM

if [ -e /tmp/synctorrent.lock ]

then

exit 1

else

touch /tmp/synctorrent.lock

lftp<<UPTOHERE

set net:limit-total-rate 0:0

set net:limit-total-max 0

set mirror:parallel-directories false

set ftp:ssl-force true

set ftp:ssl-protect-data true

set ftp:ssl-protect-list true

set net:connection-limit 10

set mirror:use-pget-n 10

set pget:min-chunk-size 100000000

set mirror:parallel-transfer-count 1

set mirror:parallel-directories false

set ssl:verify-certificate off

set net:connection-takeover true

open -p <port> -u <username>,<password> <address>

glob -d mirror --newer-than=now-7days -c --loop --only-missing </remote/ftp/folder> <“/local/nas/folder”>

quit 0

UPTOHERE

rm -f /tmp/synctorrent.lock

trap - INT TERM

exit 0

fi

EOF

else

bash /mnt/HD/HD_a2/script/notify.sh “Sync cancelled (free some space on the nas!)“

fi
