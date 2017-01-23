#!/bin/bash
BDEV=`readlink .repo/local_manifests/*`
if [ ! "$BDEV" ]
then
    if [ ! -d ".repo/local_manifests" ]
    then
        mkdir .repo/local_manifests;
    fi
    ln -s $PWD/vendor/extra/local_manifests/* .repo/local_manifests/;
    echo -e ${CL_CYN}"\nLocal Manifest linked, syncing now...\n"${CL_RST};
    repo sync -j100 --force-sync;
fi
        echo -e ${CL_GRN}" * Setup repos\n"${CL_RST}
