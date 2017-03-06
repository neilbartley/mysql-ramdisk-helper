#!/bin/bash

# Inspired by http://kotega.com/blog/2010/apr/12/mysql-ramdisk-osx/

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/mysql-ramdisk-config.sh

echo "*** Creating ramdisk"
RAMDISK_BLOCKS=$(($RAMDISK_SIZE_MB * 1048576 / 512))
diskutil erasevolume HFS+ "mysql-ramdisk" `hdiutil attach -nomount ram://$RAMDISK_BLOCKS`

echo ; echo "*** Initialising DB in ramdisk"
mysqld --initialize \
       --user mysql \
       --basedir=/usr/local \
       --datadir=$RAMDISK_MOUNT_POINT/mysql-ramdisk 2> /tmp/mysql-ramdisk-init.log ; cat /tmp/mysql-ramdisk-init.log
TEMP_PW=`cat /tmp/mysql-ramdisk-init.log | sed -n 's/.*A temporary password is generated for root@localhost: \(.*\)$/\1/p'` && rm /tmp/mysql-ramdisk-init.log

if [[ -z TEMP_PW ]] ; then
  echo ; echo "!!! Unable to retrieve temporary password"
  exit 1
fi

echo ; echo "*** Starting mysqld"
mysqld --basedir=/usr/local \
       --datadir=$RAMDISK_MOUNT_POINT/mysql-ramdisk \
       --user=mysql --log-error=$RAMDISK_MOUNT_POINT/mysql-ramdisk/mysql.ramdisk.err \
       --pid-file=/$RAMDISK_MOUNT_POINT/mysql-ramdisk/mysql.ramdisk.pid \
       --port=3308 \
       --socket=/tmp/mysql-ram.sock \
       $MYSQLD_OPTIONS &

while [ ! -e $RAMDISK_MOUNT_POINT/mysql-ramdisk/mysql.ramdisk.pid ] ; do
  sleep 2
done
echo "*** pid is:" `cat $RAMDISK_MOUNT_POINT/mysql-ramdisk/mysql.ramdisk.pid `

echo ; echo "*** Changing mysql root password"
mysql -uroot \
      --socket=/tmp/mysql-ram.sock \
      -p$TEMP_PW \
      --connect-expired-password \
      -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"

unset TEMP_PW

if [[ ! -z ENVIRONMENT_SETUP_COMMANDS ]]; then
  echo ; echo "*** Setting up environment"
  eval $ENVIRONMENT_SETUP_COMMANDS
fi
