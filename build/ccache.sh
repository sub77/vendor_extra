#!/bin/bash

USE_CCACHE=0
CCACHE_DIR=/1and/ccache/twrp6
ccache -M 5G >/dev/null

        echo -e ${CL_GRN}" * Setup ccache\n"${CL_RST}
