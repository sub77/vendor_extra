function func_setenv()
{
    if [ "${rom_type}" == "cm" ]; then myrom="cm based rom"; MY_BUILD="$CM_BUILD";
    elif [ "${rom_type}" == "du" ]; then myrom="du based rom"; MY_BUILD="$DU_BUILD";
    elif [ "${rom_type}" == "omni" ]; then myrom="omni based rom"; MY_BUILD="$CUSTOM_BUILD"; 
    else echo -e "${CL_RED} * Error: rom_type not set [vendor/extra/config.sh]${CL_RST}\n"; fi
    unset rom_type
    if [ "${with_su}" == "1" ]; then myrom="$myrom+SU"; export WITH_SU="true"; else unset WITH_SU; fi
    unset with_su
    unset CCACHE_DIR
}

function patchcommontree()
{
    for f in `test -d vendor && find -L vendor/extra/patch/*/ -maxdepth 1 -name 'apply.sh' 2> /dev/null`
    do
        echo -e "${CL_YLW}\nPatching $f${CL_RST}"
        . $f
    done
    unset f
}

function patchdevicetree()
{
    for f in `test -d device && find -L device/*/$MY_BUILD/patch -maxdepth 4 -name 'apply.sh' 2> /dev/null | sort` \
             `test -d vendor && find -L vendor/extra/patch/device/$MY_BUILD -maxdepth 1 -name 'apply.sh' 2> /dev/null | sort`
    do
        echo -e "${CL_YLW}\nPatching $f${CL_RST}"
        . $f
    done
    unset f
}

function set_stuff_for_environment()
{
    settitle
    set_java_home
    setpaths
    set_sequence_number
    patchcommontree
    patchdevicetree

    # With this environment variable new GCC can apply colors to warnings/errors
    export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
    export ASAN_OPTIONS=detect_leaks=0
}

function func_ccache()
{
    rom_dir_full=`pwd`
    rom_dir=`basename $rom_dir_full`
    export CCACHE_DIR=$ccache_dir/$rom_dir
    c_dir=`ccache -s|grep directory|cut -d '/' -f1-10`
    c_size=`ccache -s|grep 'cache size'`
    c_current=`echo $c_size|cut -d ' ' -f3-4`
    c_max=`echo $c_size|cut -d ' ' -f8-9`
    ccache -M $ccache_size >/dev/null

    if [[ "${ccache_use}" == "" || "${ccache_use}" == "0" || "${ccache_use}" == "false" ]]; then echo -e "${CL_MAG} * Disabled ccache${CL_RST}"; export USE_CCACHE=0;
    elif [ "${ccache_dir}" == "" ]; then echo -e "${CL_RED} * Error: ccache_dir not set [vendor/extra/config.sh]${CL_RST}\n"; else export USE_CCACHE=1; echo -e "${CL_GRN} * Setup ccache : ${CL_LBL}$c_current${CL_RST} of ${CL_LBL}$c_max${CL_RST} used in ${CL_LBL}$CCACHE_DIR${CL_RST}"; fi
}

function func_java()
{
    MYPYT=`python --version 2&>/tmp/mypyt|cat /tmp/mypyt`
    export mypyt=`sed q /tmp/mypyt`
    MYJDK=`java -version 2&>/tmp/myjdk|cat /tmp/myjdk`
    export myjdk=`sed q /tmp/myjdk`
    export MY_ROM=$rom_dir
    export PATH="$jdk_dir:$PATH"

        echo -e "${CL_GRN} * Checking env : ${CL_LBL}$mypyt${CL_RST} | ${CL_LBL}$myjdk${CL_RST} | ${CL_LBL}$myrom${CL_RST}"
}

function func_colors()
{
    CL_RED="\033[31m"
    CL_GRN="\033[32m"
    CL_YLW="\033[33m"
    CL_BLU="\033[34m"
    CL_MAG="\033[35m"
    CL_CYN="\033[36m"
    CL_RST="\033[0m"
    CL_B="\e[1;38;5;33m"
    CL_LBL="\e[1;38;5;81m"
    CL_GY="\e[1;38;5;242m"
    CL_GRN="\e[1;38;5;82m"
    CL_P="\e[1;38;5;161m"
    CL_PP="\e[1;38;5;93m"
    CL_RED="\e[1;38;5;196m"
    CL_Y="\e[1;38;5;214m"
    CL_W="\e[0m"
}

function func_repos()
{
    if [ ! -d ".repo/local_manifests" ]
    then
        rsync -a vendor/extra/local_manifests/*.xml .repo/local_manifests/;
        echo -e "${CL_GRN} * Local Manifest initialised, syncing now...\n${CL_RST}";
        repo sync -j100 --force-sync 2&> /dev/null;
    else
        rsync -avc --stats --exclude=du_manifest.xml vendor/extra/local_manifests/*.xml .repo/local_manifests/ >/tmp/rsync;
    fi
        if ! `sed '/xml/!d' /tmp/rsync`&> /dev/null; then repo sync -j100 --force-sync; fi

        echo -e "${CL_GRN} * Setup repos${CL_RST}"
        echo -e "${CL_LBL}   "`sed '/xml/!d' /tmp/rsync`"\n${CL_RST}"
}

function func_alias()
{
    alias be=" . build/envsetup.sh > /tmp/be && sed '/Generating\|Type/d' /tmp/be"
    alias lf="lunch du_falcon-userdebug"
    alias rs="repo sync -j1000 --force-sync"
    alias mb="mka clobber && mka bacon"
    alias mr="mka clobber && mka recoveryimage"
    alias rb="repo branches"
    alias rd="repo diff"
    alias publish="./vendor/extra/build/publish.sh"
        echo -e "${CL_GRN} * Setup aliases:${CL_LBL} type show_alias${CL_RST}"
}

function show_alias()
{
    echo -e "${CL_LBL}\n   be${CL_RST}  . build/envsetup.sh"
    echo -e "${CL_LBL}\n   lf${CL_RST}  lunch du_falcon-userdebug"
    echo -e "${CL_LBL}\n   rs${CL_RST}  repo sync -j1000 --force-sync"
    echo -e "${CL_LBL}\n   mb${CL_RST}  mka clobber && mka bacon"
    echo -e "${CL_LBL}\n   mr${CL_RST}  mka clobber && mka recoveryimage"
    echo -e "${CL_LBL}\n   rb${CL_RST}  repo branches"
    echo -e "${CL_LBL}\n   rd${CL_RST}  repo diff"
    echo -e "${CL_LBL}\n   publish${CL_RST}  upload to ftp"
    alias publish="./vendor/extra/build/publish.sh"
    echo -e "${CL_LBL}\n${CL_RST}"
}

function func_toolchain()
{
    if [ "${have_sdclang}" == "1" ]; then export SDCLANG="true"; export SDCLANG_PATH=$path_sdclang; 
    else unset SDCLANG; unset SDCLANG_PATH; fi
    unset have_sdclang
}

function func_twrp()
{
	unset TW_DEVICE_VERSION
    export TW_MAIN_VERSION_STR="`cat bootable/recovery/variables.h |grep '#define TW_MAIN_VERSION_STR'|cut -d ' ' -f 9| sed 's/"//g'`"
    export TW_DEVICE_VERSION="`date -u +%y%m%d%H%M`"
    export TW_VERSION="$TW_MAIN_VERSION_STR-$TW_DEVICE_VERSION"
    #TW_MAIN_VERSION_STR=`cat bootable/recovery/variables.h |grep '#define TW_MAIN_VERSION_STR'|cut -d ' ' -f 9`
    #TW_DEVICE_VERSION='"-0"'
    #export TW_DEVICE_VERSION=$(date -u +%y%m%d%H%M)
    #export TW_VERSION=`cat bootable/recovery/variables.h |grep '#define TW_MAIN_VERSION_STR'|cut -d ' ' -f 9`-$(date -u +%y%m%d%H%M)
}

