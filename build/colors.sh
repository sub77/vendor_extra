# COLORS
BUILD_WITH_COLORS=1
if [ ! "$BUILD_WITH_COLORS" = "0" ]; then
    CL_RED="\033[31m"
    CL_GRN="\033[32m"
    CL_YLW="\033[33m"
    CL_BLU="\033[34m"
    CL_MAG="\033[35m"
    CL_CYN="\033[36m"
    CL_RST="\033[0m"
fi

        echo -e ${CL_GRN}"\n * Setup colors\n"${CL_RST}
