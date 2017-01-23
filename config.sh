#!/bin/bash

jdk_dir="/usr/lib/jvm/java-7-openjdk/bin"

twrp=1
ccache_use=1
ccache_dir=~/ccache
ccache_size=5G

# tput color defs:
CLR_RED=(tput setaf 1)
CLR_GRN=(tput setaf 2)
CLR_YLW=(tput setaf 3)
CLR_BLU=(tput setaf 4)
CLR_MAG=(tput setaf 5)
CLR_CYN=(tput setaf 6)
CLR_WHT=(tput setaf 7)
CLR_BOLD=(tput bold)
CLR_RST=(tput sgr0)
# Shell color defs:
CL_RED="\e[1;38;5;196m"
CL_GRN="\e[1;38;5;82m"
CL_CYN="\e[1;38;5;82m"
CL_ORA="\e[1;38;5;214m"
CL_BLU="\e[1;38;5;33m"
CL_LBL="\e[1;38;5;81m"
CL_MAG="\e[1;38;5;161m"
CL_GRA="\e[1;38;5;242m"
CL_PUR="\e[1;38;5;93m"
CL_RST="\e[0m"

. "$(gettop)/vendor/extra/build/envsetup.sh"
. "$(gettop)/vendor/extra/build/env.sh"
. "$(gettop)/vendor/extra/build/ccache.sh"
if [ "${twrp}" == "1" ]; then
. "$(gettop)/vendor/extra/build/twrp.sh"
fi
