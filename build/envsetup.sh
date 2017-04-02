function func_config()
{
  source "vendor/extra/build/config"
  func_setenv
}

function func_su()
{
  if [ "${with_su}" == "1" ]; then myrom="$myrom+SU"; export WITH_SU="true"; else unset WITH_SU; fi
}

function func_ccache()
{
  export CCACHE_DIR=$ccache_dir/$rom_dir
  ccmd=$(ccache -M $ccache_size 2>&1)
  cdir=$(ccache -s|grep directory|cut -d '/' -f 3-10)
  csiz=$(ccache -s|grep 'cache size')
  ccur=$(echo $csiz|cut -d ' ' -f 3-4)
  cmax=$(echo $csiz|cut -d ' ' -f 8-9)
}

function func_toolchain()
{
  if [ "${have_sdclang}" == "1" ]; then 
    sdclang_version=`strings vendor/extra/toolchain/sdclang-3.8/bin/clang|grep Snapdragon|cut -d '"' -s -f 2|cut -b 18-51|sed 's/ /_/g'`
    export SDCLANG="true"; export SDCLANG_PATH=$path_sdclang; export SDCLANG_LTO_DEFS=$sdclang_lto_defs; export SDCLANG_VERSION=$sdclang_version;
    else unset SDCLANG; unset SDCLANG_PATH
  fi
  unset have_sdclang
}

function repo()
{
  if [ "$1" == "sync" ]; then
    echo -e "Warning: using special sync command \n${repo_sync}\n" >&2
    ${repo_sync}
  else
    /usr/bin/repo $1
  fi
}

function func_setenv()
{
	if [ "${rom_type}" == "cm" ]; then
		myrom="cm"; export MY_BUILD="$CM_BUILD";
	elif [ "${rom_type}" == "bliss" ]; then
		myrom="bliss"; export MY_BUILD="$BLISS_BUILD";
	elif [ "${rom_type}" == "du" ]; then
		myrom="du"; export MY_BUILD="$DU_BUILD";
	elif [ "${rom_type}" == "omni" ]; then
		myrom="omni"; export MY_BUILD="$CUSTOM_BUILD";
	else echo -e "\e[1;38;5;81m * Error: rom_type not set [vendor/extra/build/config]\033[0m\n";
	fi

    mypyt=$(python --version 2>&1)
    myjdk=$(java -version 2>&1 | sed q | cut -d ' ' -f 1,3 | sed 's/["]//g')

    rom_dir_full=`pwd`
    rom_dir=`basename $rom_dir_full`

    export REPO_HOME=$rom_dir_full
    export MY_ROM=$rom_dir
    export PATH="$jdk_dir:$PATH"

  func_ccache
  func_su
  func_toolchain
  
    if [[ "${ccache_use}" == "" || "${ccache_use}" == "0" || "${ccache_use}" == "false" ]]; then $ccmd; echo -e "\033[35m * Disabled ccache\033[0m"; export USE_CCACHE=0;
    elif [ "${ccache_dir}" == "" ]; then echo -e "\e[1;38;5;81m Error: ccache_dir not set [vendor/extra/config.sh]\033[0m\n"; else export USE_CCACHE=1; echo -e "\e[1;38;5;82m Setup ccache : \e[1;38;5;81m$ccur\033[0m of \e[1;38;5;81m$cmax\033[0m used in \e[1;38;5;81m$cdir\033[0m"; fi

    echo -e "\e[1;38;5;82m\n Checking env : \e[1;38;5;81m$mypyt\033[0m | \e[1;38;5;81m$myjdk\033[0m | \e[1;38;5;81m$myrom\033[0m\n"

}

function patchcommontree()
{
    for f in `test -d vendor && find -L vendor/extra/patch/*/ -maxdepth 1 -name 'apply.sh' 2> /dev/null`
    do
        echo -e "\e[1;38;5;242m\nPatching $f\033[0m"
        . $f
    done
    unset f
}

function patchdevicetree()
{
    for f in `test -d device && find -L device/*/$MY_BUILD/patch -maxdepth 4 -name 'apply.sh' 2> /dev/null | sort` \
             `test -d vendor && find -L vendor/extra/patch/device/$MY_BUILD -maxdepth 1 -name 'apply.sh' 2> /dev/null | sort`
    do
        echo -e "\e[1;38;5;242m\nPatching $f\033[0m"
        . $f
    done
    unset f
}

function set_stuff_for_environment()
{
    settitle
    set_java_home
    setpaths
    set_sequence_number
  if [ "${rom_type}" ]; then
    #func_setenv
    patchcommontree
    patchdevicetree
  fi
  if [ "${rom_type}" == "bliss" ]; then 
    export ANDROID_BUILD_TOP=$(gettop)
  fi
    # With this environment variable new GCC can apply colors to warnings/errors
    export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
    export ASAN_OPTIONS=detect_leaks=0

  if [ "${rom_type}" == "twrp" ]; then 
    export TW_MAIN_VERSION="`cat bootable/recovery/variables.h |grep '#define TW_MAIN_VERSION_STR'|cut -d ' ' -f 9| sed 's/"//g'`"
    export TW_DEV_VERSION="`cat vendor/extra/vcontrol/TW_REC_BUILD_NUMBER-${TARGET_PRODUCT}.TXT`"
    export TW_NEW="`cat bootable/recovery/variables.h |grep '#define TW_MAIN_VERSION_STR'|cut -d ' ' -f 9| sed 's/"//g'| sed 's/\.//g'`"
    export TW_OLD="`cat vendor/extra/vcontrol/TW_REC_MAIN_VERSION-${TARGET_PRODUCT}.TXT`"
  fi
}

function set_sequence_number()
{
    export BUILD_ENV_SEQUENCE_NUMBER=10
}

# Force JAVA_HOME to point to java 1.7/1.8 if it isn't already set.
function set_java_home() {
    # Clear the existing JAVA_HOME value if we set it ourselves, so that
    # we can reset it later, depending on the version of java the build
    # system needs.
    #
    # If we don't do this, the JAVA_HOME value set by the first call to
    # build/envsetup.sh will persist forever.
    if [ -n "$ANDROID_SET_JAVA_HOME" ]; then
      export JAVA_HOME=""
    fi

    if [ ! "$JAVA_HOME" ]; then
      if [ -n "$LEGACY_USE_JAVA7" ]; then
        echo Warning: Support for JDK 7 will be dropped. Switch to JDK 8.
        case `uname -s` in
            Darwin)
                export JAVA_HOME=$(/usr/libexec/java_home -v 1.7)
                ;;
            *)
                export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64
                ;;
        esac
      else
        case `uname -s` in
            Darwin)
                export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)
                ;;
            *)
                export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
                ;;
        esac
      fi

      # Keep track of the fact that we set JAVA_HOME ourselves, so that
      # we can change it on the next envsetup.sh, if required.
      export ANDROID_SET_JAVA_HOME=true
    fi
}

function addcompletions()
{
    local T dir f

    # Keep us from trying to run in something that isn't bash.
    if [ -z "${BASH_VERSION}" ]; then
        return
    fi

    # Keep us from trying to run in bash that's too old.
    if [ ${BASH_VERSINFO[0]} -lt 3 ]; then
        return
    fi

    dir="sdk/bash_completion"
    if [ -d ${dir} ]; then
        for f in `/bin/ls ${dir}/[a-z]*.bash 2> /dev/null`; do
            echo -e "\e[1;38;5;242m including $f\033[0m\n"
            . $f
        done
    fi
}

unset -f

func_config
