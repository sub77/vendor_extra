#!/bin/bash

TW_DEVICE_ORIG_VERSION=`sed -n '/#define TW_VERSION_STR/p' bootable/recovery/variables.h |cut -d '"' -f2`
TW_DEVICE_MAIN_VERSION=`sed -n '/#define TW_VERSION_STR/p' bootable/recovery/variables.h |cut -d '"' -f2|cut -d '-' -f1`
TW_DEVICE_VERSION="10"

function reset_tw_version_str()
{
sed -i '/#define TW_VERSION_STR/s/-[0-9]"//g' bootable/recovery/variables.h
}

sed -i '/#define TW_VERSION_STR/s/ /#define TW_VERSION_STR              "3.0.3-0"/g' bootable/recovery/variables.h

sed -i '/#define TW_VERSION_STR/s/-[0-9]/-'"${TW_DEVICE_VERSION}"'/g' bootable/recovery/variables.h

        echo -e ${CL_GRN}"   TWRP Orig version: $TW_DEVICE_ORIG_VERSION\n"${CL_RST}
        echo -e ${CL_GRN}"   TWRP Main version: $TW_DEVICE_MAIN_VERSION\n"${CL_RST}
        echo -e ${CL_GRN}"   TWRP Dev. version: $TW_DEVICE_VERSION\n"${CL_RST}
