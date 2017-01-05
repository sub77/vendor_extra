#!/bin/bash
export PATH="/mnt/roms:/usr/lib/jvm/java-7-openjdk/bin:$PATH"
MYPYT=`python --version 2&>/tmp/mypyt|cat /tmp/mypyt`
export mypyt=`sed q /tmp/mypyt`
MYJDK=`java -version 2&>/tmp/myjdk|cat /tmp/myjdk`
export myjdk=`sed q /tmp/myjdk`

        echo -e ${CL_GRN}" * Checking environment\n"${CL_RST}
        echo -e ${CL_GRN}"   $mypyt"${CL_RST}
        echo -e ${CL_GRN}"   $myjdk\n"${CL_RST}
