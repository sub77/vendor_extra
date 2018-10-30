repopick_omnirom="./vendor/omni/build/tools/repopick.py"

# topic:flex-9.0
echo -e ${rst}${bldylw} x ${rst}${bldblu}
$repopick_omnirom 32664

echo -e ${rst}${bldylw} x ${rst}${bldblu}
$repopick_omnirom 32665

# topic:wifi-sta-ap-concurrency
echo -e ${rst}${bldylw} x ${rst}${bldblu}
$repopick_omnirom 32593

echo -e ${rst}${bldylw} x ${rst}${bldblu}
$repopick_omnirom 32594

echo -e ${rst}${bldylw} x ${rst}${bldblu}
$repopick_omnirom 32595

echo -e ${rst}${bldylw} x ${rst}${bldblu}
$repopick_omnirom 32596

echo -e ${rst}${bldylw} x ${rst}${bldblu}
$repopick_omnirom 32602

# misc
echo -e ${rst}${bldylw} "bionic: hack for pthread mutex bug for old camera blob" ${rst}${bldblu}
$repopick_omnirom 32643

echo -e ${rst}${bldylw} "omni: add hours and minutes to ro.omni.version" ${rst}${bldblu}
$repopick_omnirom -f 32545

###
echo -e ${rst}
