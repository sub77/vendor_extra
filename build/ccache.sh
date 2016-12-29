rom_dir_full=`pwd`
rom_dir=`basename $rom_dir_full`

export CCACHE_DIR=$ccache_dir/$rom_dir
ccache -M $ccache_size >/dev/null

c_dir=`ccache -s|grep directory|cut -d '/' -f1-10`
c_size=`ccache -s|grep 'cache size'`
c_current=`echo $c_size|cut -d ' ' -f3-4`
c_max=`echo $c_size|cut -d ' ' -f8-9`

if [[ "${ccache_use}" == "" || "${ccache_use}" == "0" || "${ccache_use}" == "false" ]]; then echo -e ${CL_GRN}" * Disabled ccache\n"${CL_RST};USE_CCACHE=0; else USE_CCACHE=1; fi

if [ "${USE_CCACHE}" == "1" ]; then
if [ "${ccache_dir}" == "" ]; then echo -e ${CL_RED}" * Error: ccache_dir not set [vendor/extra/config.sh]\n"${CL_RST}; break; else echo -e ${CL_GRN}" * Setup ccache:${CL_RST} "${CL_LB}$c_current ${CL_RST}"of" ${CL_LB}$c_max ${CL_RST} "used in"  ${CL_LB}$c_dir  ${CL_RST}"\n"; fi
fi


