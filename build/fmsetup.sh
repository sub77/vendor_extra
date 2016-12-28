
function subcccache() {
export USE_CCACHE=1
export CCACHE_DIR=/1and/ccache/du
ccache -M 15G
ccache -s
 echo -e ${CL_YLW}"\nccache activated\n"${CL_RST}
}

function subcolors() {
. ./vendor/extra/build/colors
 echo -e ${CL_YLW}"\ncolors activated\n"${CL_RST}
}

function subpatch() {
. ./vendor/extra/patch/apply.sh
 echo -e ${CL_YLW}"\nmyenvsetup activated\n"${CL_RST}
}

subcolors
subcccache
subpatch


