#!/bin/bash

BDEV=`readlink .repo/local_manifests/*`

if [ ! "$BDEV" ]
then
    if [ ! -d ".repo/local_manifests" ]
    then
        mkdir .repo/local_manifests;
    fi
    ln -s $PWD/vendor/extra/local_manifests/* .repo/local_manifests/;
    echo -e ${CL_GRN}" * Local Manifest initialised, syncing now...\n"${CL_RST};
    repo sync -j100 --force-sync &> /tmp/checksync;
    sed -i '/discard/!d' /tmp/checksync
    sed -i 's/^/echo -e ${CL_CYN}"   - /' /tmp/checksync
    sed -i '/discarding/s/commits/commits"${CL_RST}; echo /g' /tmp/checksync
    source /tmp/checksync
fi

REPODES=`find .repo/local_manifests/ -type l | wc -l`
REPOSRC=`find vendor/extra/local_manifests/ -type f | wc -l`

if [[ ! "$REPOSRC" == "$REPODES" ]]
then
    echo -e ${CL_CYN}" * Found new manifest...\n"${CL_RST};
    for file in `find .repo/local_manifests/ -type l`; do rm "$file"; done
    ln -s $PWD/vendor/extra/local_manifests/* .repo/local_manifests/&>/dev/null;
    echo -e ${CL_CYN}"\n * New Manifest linked, syncing now...\n"${CL_RST};
    repo sync -j100 --force-sync -q;
    #cp /tmp/checksync /tmp/checksync2
    #sed -i '/discard/!d' /tmp/checksync
    #sed -i 's/^/echo -e ${CL_CYN}"   - /' /tmp/checksync
    #sed -i '/discarding/s/commits/commits"${CL_RST}; echo /g' /tmp/checksync
    #source /tmp/checksync
    #sed -i '/done/!d' /tmp/checksync2
fi
        cd system/extras/multirom
        git submodule update --init
        cd ..; cd ..; cd ..
        echo -e ${CL_GRN}" * Setup repos"${CL_RST}
