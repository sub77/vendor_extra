# COLORS
BUILD_WITH_COLORS=1
if [ ! "$BUILD_WITH_COLORS" = "0" ]; then
    OCL_RED="\033[31m"
    OCL_GRN="\033[32m"
    OCL_YLW="\033[33m"
    OCL_BLU="\033[34m"
    OCL_MAG="\033[35m"
    OCL_CYN="\033[36m"
    OCL_RST="\033[0m"
       CL_B="\e[1;38;5;33m"
      CL_LB="\e[1;38;5;81m"
      CL_GY="\e[1;38;5;242m"
       CL_GRN="\e[1;38;5;82m"
       CL_P="\e[1;38;5;161m"
      CL_PP="\e[1;38;5;93m"
     CL_RED="\e[1;38;5;196m"
       CL_Y="\e[1;38;5;214m"
       CL_W="\e[0m"

fi

        echo -e ${CL_GRN}"\n * Setup colors\n"${CL_RST}