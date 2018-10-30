function analyse_log()
{
    # Check compile result and patch file success
    echo -e "\n***************************************************"
    echo -e "${CL_GRN}Check for compile errors:"
    echo -e ${CL_RED}
    grep " error" ./compile.log
    grep "forbidden warning" ./compile.log
    grep "note: previous definition is here" ./compile.log
    grep "fatal error:" ./compile.log
    grep "terminate" ./compile.log
    grep "ninja: error:" ./compile.log
    grep "needed" ./compile.log
    grep -A 1 "ERROR" ./compile.log
    echo -e ${CL_RST}

    echo -e "***************************************************"
}

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

function func_ccache()
{
  if [[ ! -f $(which ccache &>/dev/null) ]]; then
    alias ccache='./prebuilts/misc/linux-x86/ccache/ccache'
  fi


  if [[ "${ccache_use}" == "" || "${ccache_use}" == "0" || "${ccache_use}" == "false" ]]; then
    echo -e ${ylw}" * Disabled ccache"${txtrst};
    export USE_CCACHE=0;
  elif [ "${ccache_dir}" == "" ]; then
    echo -e ${red}"Error: ccache_dir not set [vendor/extra/config]"${txtrst};
  else
    export USE_CCACHE=1
    mkdir -p "$CCACHE_DIR" 2>/dev/null
    export CCACHE_DIR=${ccache_dir}
    ccmd=$(ccache -M $ccache_size 2>&1)
    cdir=$(ccache -s|grep directory|cut -d '/' -f 3-10)
    csiz=$(ccache -s|grep 'cache size')
    ccur=$(echo $csiz|cut -d ' ' -f 3-4)
    cmax=$(echo $csiz|cut -d ' ' -f 8-9)
    echo -e $(ccache -s) >/dev/null
    echo -e ${txtbld}"Setup ccache : ${rst}${cya}$ccur /${cya} $cmax ($cdir)"${rst};
  fi
}

function func_colors()
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

function func_config()
{
  source "vendor/extra/config/rom_config"
}

function mka2() {
    m "$@" | tee ./compile.log
    analyse_log
}

function opendelta()
{
#read -p "Continue with OpenDelta(y/n)?" CONT
#if [ "$CONT" = "y" ]; then
  cd /mnt/roms/omnirom/vendor/extra/opendelta
  bash opendelta.sh $CUSTOM_BUILD
  if [ $? -eq 0 ]; then
    echo -e "no error, starting upload"
    bash upload.sh $CUSTOM_BUILD
  else
    echo -e "error. no upload"
  fi
#else
#  echo "abort";
#fi
croot
}

function func_patchcommon()
{
    for f in `test -d vendor && find -L vendor/extra/patch -maxdepth 1 -name 'apply.sh' 2> /dev/null`
    do
        pvar=$(dirname $f)/common
        echo -e ${bldppl}${pa}"applying common patches" - $pvar${rst}
        . $f
    done
    unset f
}

function func_patchdevice()
{
    for f in `test -d vendor && find -L vendor/extra/patch -maxdepth 1 -name 'apply.sh' 2> /dev/null`
    do
        pvar=$(dirname $f)/device/$CUSTOM_BUILD
        echo -e ${bldppl}${pa}"applying $CUSTOM_BUILD patches" - $pvar${rst}
        . $f
    done
    unset f
}

function func_repopicker() {
    echo -e ${bldppl}${pa}"repopicking"${rst}
    . `test -d vendor && find -L vendor/extra/patch/repo -maxdepth 1 -name 'repopicker.sh'`
}

function set_stuff_for_environment()
{
    settitle
    setpaths
    set_sequence_number
    func_patchdevice
    func_patchcommon
    func_repopicker

    # With this environment variable new GCC can apply colors to warnings/errors
    export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
    export ASAN_OPTIONS=detect_leaks=0
}

func_colors
func_config
func_ccache
