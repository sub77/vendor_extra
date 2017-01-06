#my_rom="OmniROM"
ccache_use=1
ccache_dir=~/ccache
ccache_size=15G

rom_dir_full=`pwd`
rom_dir=`basename $rom_dir_full`

export MY_ROM=$rom_dir
export USE_CCACHE=1
