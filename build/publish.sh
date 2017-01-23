#!/bin/bash

# Script to generate delta files for OpenDelta - by Jorrit 'Chainfire' Jongma

# Get device either from $DEVICE set by calling script, or first parameter

if [ "$DEVICE" == "" ]; then
    if [ "$1" != "" ]; then
        DEVICE=$1
    fi
fi

if [ "$DEVICE" == "" ]; then
    echo "Abort: no device set" >&2
    exit 1
fi

# ------ CONFIGURATION ------

HOME="/roms"
ROMBASE="twrp"
FILEMASK="twrp-"

SERVER_AFH="ftp://uploads.androidfilehost.com"
SERVER_BB="ftp.basketbuild.com"

my_rc_file=~/.xdarc

my_account_afh="AFH FTP Login"
my_account_bb="BB FTP Login"
my_account_xda="XDA Forum Login"

if [ ! -f ${my_rc_file} ]; then touch ${my_rc_file}; chmod 600 ${my_rc_file}; else source ${my_rc_file}; fi

if [ -n "$my_account_afh" ] ; then
    if [[ ! -n "$my_login_afh" || ! -n "$my_passw_afh" ]] ; then
        echo -e "$my_account_afh"
        read -p "Username:" my_login_afh
        read -p "Password:" my_passw_afh
            if [ -n "$my_login_afh" ] && [ -n "$my_passw_afh" ] ; then echo -e "my_login_afh=$my_login_afh\nmy_passw_afh=$my_passw_afh" >> ${my_rc_file} ; echo "USERDATA written to ${my_rc_file}"; else echo "ERROR. no data written!"; fi
    fi
fi
if [ -n "$my_account_bb" ] ; then
    if [[ ! -n "$my_login_bb" || ! -n "$my_passw_bb" ]] ; then
        echo -e "$my_account_bb"
        read -p "Username:" my_login_bb
        read -p "Password:" my_passw_bb
            if [ -n "$my_login_bb" ] && [ -n "$my_passw_bb" ] ; then echo -e "my_login_bb=$my_login_bb\nmy_passw_bb=$my_passw_bb" >> ${my_rc_file} ; echo "USERDATA written to ${my_rc_file}"; else echo "ERROR. no data written!"; fi
    fi
fi
if [ -n "$my_account_xda" ] ; then
    if [[ ! -n "$my_login_xda" || ! -n "$my_passw_xda" ]] ; then
    echo -e "\e[1;38;5;81m"$my_account_xda"\e[0m"
    read -p "Username:" my_login_xda
    read -p "Password:" my_passw_xda
        if [ -n "$my_login_xda" ] && [ -n "$my_login_xda" ] ; then echo -e "my_login_xda=$my_login_xda\nmy_passw_xda=$my_passw_xda" >> ${my_rc_file} ; echo "USERDATA written to ${my_rc_file}"; else echo "ERROR. no data written!"; fi
    fi
fi

#source $my_rc_file

# FTP Directory where file is located
DIR_DELTA="$ROM/delta/$DEVICE/"
DIR_FULL="/$ROM/full/$DEVICE/"
#VERBOSE="-v"
#TESTMODE=1

FILE_MATCH_IMG=$FILEMASK*.img
FILE_MATCH_TAR=$FILEMASK*.tar
FILE_PATH=$HOME/$ROMBASE/out/target/product/$DEVICE

# ------ PROCESS ------

getFileNameImg() {
    echo ${1##*/}
}

getFileNameTar() {
    echo ${1##*/}
}

getFileNameNoExt() {
    echo ${1%.*}
}



FILE_IMG=$(getFileNameImg $(ls -1 $FILE_PATH/$FILE_MATCH_IMG))
FILE_TAR=$(getFileNameTar $(ls -1 $FILE_PATH/$FILE_MATCH_TAR))

FILE_BASE=$(getFileNameNoExt $FILE_IMG)

export FILE_UPLOAD="$FILE_PATH/$FILE_IMG"
echo $FILE_UPLOAD

curl $VERBOSE -T $FILE_UPLOAD -u $my_login_afh:$my_passw_afh $SERVER_AFH/
curl $VERBOSE -T $FILE_UPLOAD -u $my_login_bb:$my_passw_bb $SERVER_BB/.tmp/



