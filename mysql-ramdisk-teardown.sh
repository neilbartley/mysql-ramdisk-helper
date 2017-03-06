#!/bin/bash

CFGDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $CFGDIR/mysql-ramdisk-config.sh

echo "*** Stopping mysqld"
# We don't have to be nice about this!
kill -9 `cat $RAMDISK_MOUNT_POINT/mysql-ramdisk/mysql.ramdisk.pid`

echo; echo "*** Unmounting ramdisk"
diskutil eject $RAMDISK_MOUNT_POINT/mysql-ramdisk
