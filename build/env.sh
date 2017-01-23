#!/bin/bash

rom_dir_full=`pwd`
rom_dir=`basename $rom_dir_full`

export MY_ROM=$rom_dir

MYPYT=`python --version 2&>/tmp/mypyt|cat /tmp/mypyt`
export mypyt=`sed q /tmp/mypyt`
MYJDK=`java -version 2&>/tmp/myjdk|cat /tmp/myjdk`
export myjdk=`sed q /tmp/myjdk`

export PATH="$jdk_dir:$PATH"

        echo -e ${CL_GRN}" * Checking environment\n"${CL_RST}
        echo -e ${CL_GRN}"   $mypyt"${CL_RST}
        echo -e ${CL_GRN}"   $myjdk\n"${CL_RST}
