function apply () {
  filename=$1
  shift
  patch_args=$*

  gotSubject=no
  msg=""

  cat $filename | while read line; do
  if [ "$line" == "---" ]; then


    patch $patch_args -p1 < $filename --no-backup-if-mismatch --version-control=never -F3 &>/dev/null
    git commit -a -m "$msg" &>/dev/null
    break
    fi
    if [ "$gotSubject" == "no" ]; then
      hdr=(${line//:/ })
      if [ "${hdr[0]}" == "Subject" ]; then
        gotSubject=yes
        msg="${hdr[@]:3}"
      fi
    else
      msg="$msg $line"
    fi
  done
}

function colors()
{
if [ ! "$BUILD_WITH_COLORS" = "0" ]; then
    CL_RED="\033[31m"
    CL_GRN="\033[32m"
    CL_YLW="\033[33m"
    CL_BLU="\033[34m"
    CL_MAG="\033[35m"
    CL_CYN="\033[36m"
    CL_RST="\033[0m"
    red=$(tput setaf 1)             #  red
    grn=$(tput setaf 2)             #  green
    ylw=$(tput setaf 3)             #  yellow
    blu=$(tput setaf 4)             #  blue
    ppl=$(tput setaf 5)             #  purple
    cya=$(tput setaf 6)             #  cyan
    rst=$(tput sgr0)                #  Reset
    txtbld=$(tput bold)             #  Bold
    bldred=${txtbld}$(tput setaf 1) #  red
    bldgrn=${txtbld}$(tput setaf 2) #  green
    bldylw=${txtbld}$(tput setaf 3) #  yellow
    bldblu=${txtbld}$(tput setaf 4) #  blue
    bldppl=${txtbld}$(tput setaf 5) #  purple
    bldcya=${txtbld}$(tput setaf 6) #  cyan
    txtrst=$(tput sgr0)             #  Reset
    rev=$(tput rev)                 #  Reverse color
    pplrev=${rev}$(tput setaf 5)
    cyarev=${rev}$(tput setaf 6)
    ylwrev=${rev}$(tput setaf 3)
    blurev=${rev}$(tput setaf 4)
    pa="\n"
    par=$(tput sgr0)${pa}
fi
}

function mka() {
    m -j "$@"
}

function patchcommon()
{
    for f in `test -d vendor && find -L vendor/extra/patch -maxdepth 1 -name 'apply.sh' 2> /dev/null`
    do
        pvar=$(dirname $f)/common
        echo -e ${bldppl}${pa}"applying common patches" - $pvar${rst}
        . $f
    done
    unset f
}

function patchdevice()
{
    for f in `test -d vendor && find -L vendor/extra/patch -maxdepth 1 -name 'apply.sh' 2> /dev/null`
    do
        pvar=$(dirname $f)/device/$CUSTOM_BUILD
        echo -e ${bldppl}${pa}"applying $CUSTOM_BUILD patches" - $pvar${rst}
        . $f
    done
    unset f
}

function set_stuff_for_environment()
{
    settitle
    setpaths
    set_sequence_number
    colors
    patchcommon
    patchdevice
    # With this environment variable new GCC can apply colors to warnings/errors
    export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
    export ASAN_OPTIONS=detect_leaks=0
}
