#!/bin/bash
REPODES=`find .repo/local_manifests/ -type l | wc -l`
REPOSRC=`find vendor/extra/local_manifests/ -type f | wc -l`
BDEV=`readlink .repo/local_manifests/*`

if [[ ! "$REPOSRC" ==  "$REPODES" ]]
then
    echo -e ${CL_CYN}" Found new manifest...\n"${CL_RST};
    for file in `find .repo/local_manifests/ -type l`; do rm "$file"; done
    ln -s $PWD/vendor/extra/local_manifests/* .repo/local_manifests/&>/dev/null;
    echo -e ${CL_CYN}"\n New Manifest linked, syncing now...\n"${CL_RST};
    repo sync -j100 --force-sync;
fi
if [ ! "$BDEV" ]
then
    if [ ! -d ".repo/local_manifests" ]
    then
        mkdir .repo/local_manifests;
    fi
    ln -s $PWD/vendor/extra/local_manifests/* .repo/local_manifests/;
    echo -e ${CL_CYN}"\n Local Manifest linked, syncing now...\n"${CL_RST};
    repo sync -j100 --force-sync;
fi
        echo -e ${CL_GRN}" * Setup repos"${CL_RST}
