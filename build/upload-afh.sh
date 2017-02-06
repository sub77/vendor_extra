# Variables
OUTDIR=/roms/twrp/out/target/product/matisse/upload
SOURCE=~/android/aosp/pure

MY_PASSWD_FILE=/roms/.xdarc

# BasketBuild FTP address
BBHOST="ftp.basketbuild.com"
BBUSER=`cat $MY_PASSWD_FILE | grep my_login_bb | awk -F'my_login_bb=' '{ print $2 }'`
BBPASS=`cat $MY_PASSWD_FILE | grep my_passw_bb | awk -F'my_passw_bb=' '{ print $2 }'`

# Androidfilehost FTP address
AFHHOST="uploads.androidfilehost.com"
AFHUSER=`cat $MY_PASSWD_FILE | grep my_login_afh | awk -F'my_login_afh=' '{ print $2 }'`
AFHPASS=`cat $MY_PASSWD_FILE | grep my_passw_afh | awk -F'my_passw_afh=' '{ print $2 }'`

# Colors
green=`tput setaf 2`
red=`tput setaf 1`
yellow=`tput setaf 3`
reset=`tput sgr0`

upload-bb() {
  cd ${OUTDIR}
  lftp <<INPUT_END
  open ftp://$BBHOST
  user $BBUSER $BBPASS
  set sftp:auto-confirm yes
  mput *.*
  exit
INPUT_END
}

upload-afh() {
  cd ${OUTDIR}
  lftp <<INPUT_END
  open sftp://$AFHHOST
  user $AFHUSER $AFHPASS
  set sftp:auto-confirm yes
  mput *.*
  exit
INPUT_END
}

if [ "$TARGET_RECOVERY_IS_MULTIROM" == "true" ]; then
    echo -e "\n$green [ ]$yellow TWRP $green[x]$yellow MultiROM |$yellow Device: $green $TARGET_PRODUCT\n$reset"  
    else
    echo -e "\n$green [x]$yellow TWRP $green[ ]$yellow MultiROM |$yellow Device: $green $TARGET_PRODUCT\n$reset"  
fi;

echo "$RECOVERY_IMG"

echo -e "$yellow UPLOADING TO BASKETBUILD"$green
upload-bb
echo -e $reset

echo -e "$yellow UPLOADING TO ANDROIDFILEHOST"$green
upload-afh
echo -e $reset

