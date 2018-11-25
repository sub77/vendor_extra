repopick_omnirom="./vendor/omni/build/tools/repopick.py"

# topic:wifi-sta-ap-concurrency
# echo -e ${rst}${bldylw} wifi-sta-ap-concurrency 1 ${rst}${bldblu}
# $repopick_omnirom 32593

# echo -e ${rst}${bldylw} wifi-sta-ap-concurrency 2 ${rst}${bldblu}
# $repopick_omnirom 32594

# echo -e ${rst}${bldylw} wifi-sta-ap-concurrency 3 ${rst}${bldblu}
# $repopick_omnirom 32595

# echo -e ${rst}${bldylw} wifi-sta-ap-concurrency 4 ${rst}${bldblu}
# $repopick_omnirom 32596

# echo -e ${rst}${bldylw} wifi-sta-ap-concurrency 5 ${rst}${bldblu}
# $repopick_omnirom 32602

# misc
## echo -e ${rst}${bldylw} "bionic: hack for pthread mutex bug for old camera blob" ${rst}${bldblu}
#$repopick_omnirom 32643

echo -e ${rst}${bldylw} "omni: add hours and minutes to ro.omni.version" ${rst}${bldblu}
$repopick_omnirom -f 32545

# testing
#echo -e ${rst}${bldylw} "framework_base: Add ICCID into CarrierIdentifier" ${rst}${bldblu}
#$repopick_omnirom 32860


echo -e ${rst}${bldylw} "android_build: android-9.0: [1/3] build/make: Add soong flag for legacy mutex handle" ${rst}${bldblu}
echo -e ${rst}${bldylw} "android_build_soong: android-9.0: [2/3] build/soong: Add soong flag for legacy mutex handle" ${rst}${bldblu}
echo -e ${rst}${bldylw} "android_bionic: android-9.0: [3/3] Restore pre-P mutex behavior for legacy blobs" ${rst}${bldblu}
$repopick_omnirom 32924
$repopick_omnirom 32925
$repopick_omnirom 32926

echo -e ${rst}${bldylw} "32940: softap: Suppress warnings to be treated as errors" ${rst}${bldblu}
$repopick_omnirom 32940

###
echo -e ${rst}
