#!/bin/bash
# FTP mirror script for BasketBuild.
# Based on http://serverfault.com/questions/24622/how-to-use-rsync-over-ftp

if [ -z "$1" ] || [ -z "$2" ]
then
    echo "Insufficient parameters. Usage: $FUNCNAME [local path] [remote path]"
    exit 0
fi

MY_PASSWD_FILE=/roms/.xdarc

# BasketBuild FTP address
BBHOST="s.basketbuild.com"

# Androidfilehost FTP address
AFHHOST="uploads.androidfilehost.com"

# Login information BasketBuild
BBUSER=`cat $MY_PASSWD_FILE | grep my_login_bb | awk -F'my_login_bb=' '{ print $2 }'`
BBPASS=`cat $MY_PASSWD_FILE | grep my_passw_bb | awk -F'my_passw_bb=' '{ print $2 }'`

# Login information Androidfilehost
AFHUSER=`cat $MY_PASSWD_FILE | grep my_login_afh | awk -F'my_login_afh=' '{ print $2 }'`
AFHPASS=`cat $MY_PASSWD_FILE | grep my_passw_afh | awk -F'my_passw_afh=' '{ print $2 }'`

# Full URL for FTP connection
BBFTPURL="$BBUSER:$BBPASS@$BBHOST"
AFHFTPURL="$AFHUSER:$AFHPASS@$AFHHOST"

# Local dir on codefi.re server
BBLOCAL_DIR=$1
AFHLOCAL_DIR=$1

# Remote dir on BasketBuild server
BBREMOTE_DIR=$2
AFHREMOTE_DIR=$2

# Uncomment this to delete old files
# BBDELETE="--delete"
# AFHDELETE="--delete"

# Run sync between codefi.re and BasketBuild using lftp

lftp -c "set ftp:list-options -a;
set ftp:passive-mode off;
set net:reconnect-interval-base 5;
set net:max-retries 2;
set cmd:fail-exit true;
open '$BBFTPURL';
lcd $BBLOCAL_DIR;
cd $BBREMOTE_DIR;
mirror --reverse \
    $BBDELETE \
    --use-cache \
    --parallel=2 \
    --verbose \
    --exclude-glob *.md5sum"

echo $AFHUSER
echo $AFHPASS
echo $AFHHOST

lftp -c "set ftp:list-options -a;
set ftp:passive-mode off;
set net:reconnect-interval-base 5;
set net:max-retries 2;
set cmd:fail-exit true;
set ssl:verify-certificate false;
open '$AFHFTPURL';
lcd $AFHLOCAL_DIR;
cd $AFHREMOTE_DIR;
mput *.* \
    $AFHDELETE \
    --use-cache \
    --parallel=2 \
    --verbose \
    --exclude-glob *.md5sum"
