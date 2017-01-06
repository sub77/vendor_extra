#!/bin/bash
jdk_dir="/usr/lib/jvm/java-8-openjdk/bin"
ccache_use=0
ccache_dir=~/ccache
ccache_size=5G

rom_dir_full=`pwd`
rom_dir=`basename $rom_dir_full`

# Shell color defs:
CL_RED="\e[1;38;5;196m"
CL_GRN="\e[1;38;5;82m"
CL_CYN="\e[1;38;5;82m"
CL_ORA="\e[1;38;5;214m"
CL_BLU="\e[1;38;5;33m"
CL_LBL="\e[1;38;5;81m"
CL_MAG="\e[1;38;5;161m"
CL_GRA="\e[1;38;5;242m"
CL_PUR="\e[1;38;5;93m"
CL_RST="\e[0m"

export PATH="/mnt/roms:$jdk_dir:$PATH"
MYPYT=`python --version 2&>/tmp/mypyt|cat /tmp/mypyt`
export mypyt=`sed q /tmp/mypyt`
MYJDK=`java -version 2&>/tmp/myjdk|cat /tmp/myjdk`
export myjdk=`sed q /tmp/myjdk`

export MY_ROM=$rom_dir

TW_DEVICE_ORIG_VERSION=`sed -n '/#define TW_VERSION_STR/p' bootable/recovery/variables.h |cut -d '"' -f2`
TW_DEVICE_MAIN_VERSION=`sed -n '/#define TW_VERSION_STR/p' bootable/recovery/variables.h |cut -d '"' -f2|cut -d '-' -f1`
TW_DEVICE_VERSION="10"

function reset_tw_version_str()
{
sed -i '/#define TW_VERSION_STR/s/-[0-9]"//g' bootable/recovery/variables.h
}

sed -i '/#define TW_VERSION_STR/s/ /#define TW_VERSION_STR              "3.0.3-0"/g' bootable/recovery/variables.h

sed -i '/#define TW_VERSION_STR/s/-[0-9]/-'"${TW_DEVICE_VERSION}"'/g' bootable/recovery/variables.h

        echo -e ${CL_GRN}" * Checking environment\n"${CL_RST}
        echo -e ${CL_GRN}"   $mypyt"${CL_RST}
        echo -e ${CL_GRN}"   $myjdk\n"${CL_RST}
        echo -e ${CL_GRN}"   TWRP Orig version: $TW_DEVICE_ORIG_VERSION\n"${CL_RST}
        echo -e ${CL_GRN}"   TWRP Main version: $TW_DEVICE_MAIN_VERSION\n"${CL_RST}
        echo -e ${CL_GRN}"   TWRP Dev. version: $TW_DEVICE_VERSION\n"${CL_RST}



