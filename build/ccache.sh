#!/bin/bash

export USE_CCACHE=1
export CCACHE_DIR=/1and/ccache/OmniROM
ccache -M 15G >/dev/null

        echo -e ${CL_GRN}" * Setup ccache\n"${CL_RST}
