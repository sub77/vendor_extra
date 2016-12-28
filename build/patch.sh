#PATCHING COMMON
function patchcommontree()
{
for f in `test -d device && find -L vendor/extra/products/common/patch -maxdepth 4 -name 'apply.sh' 2> /dev/null`
do
    echo -e ${CL_BLU}"\nPatching common-tree -> $f\n"${CL_RST}
    . $f
done

unset f
}

# PATCHING DEVICE
function patchdevicetree()
{
for f in `test -d device && find -L vendor/extra/products/$DU_BUILD/patch -maxdepth 4 -name 'apply.sh' 2> /dev/null`
do
    echo -e ${CL_MAG}"\nPatching device-tree -> $f\n"${CL_RST}
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
    patchcommontree
    patchdevicetree

    export ANDROID_BUILD_TOP=$(gettop)
    # With this environment variable new GCC can apply colors to warnings/errors
    export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
    export ASAN_OPTIONS=detect_leaks=0
}
