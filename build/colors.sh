# COLORS
BUILD_WITH_COLORS=1
if [ ! "$BUILD_WITH_COLORS" = "0" ]; then
    CL_RED="\e[1;38;5;196m"
    CL_GRN="\e[1;38;5;82m"
    CL_ORA="\e[1;38;5;214m"
    CL_BLU="\e[1;38;5;33m"
    CL_LBL="\e[1;38;5;81m"
    CL_MAG="\e[1;38;5;161m"
    CL_GRA="\e[1;38;5;242m"
    CL_PUR="\e[1;38;5;93m"
    CL_RST="\e[0m"
fi

        echo -e ${CL_GRN}"\n * Setup colors\n"${CL_RST}
