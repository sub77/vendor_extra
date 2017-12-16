repopick_substratum="./vendor/extra/build/tools/repopick_substratum.py"

echo "substratum"
echo -e
PROJECT_NAME=android_frameworks_base
$repopick_substratum 460
cd frameworks/base && gcpc
croot
$repopick_substratum 461
cd frameworks/base && gcpc
croot
$repopick_substratum 462
cd frameworks/base && gcpc
croot
$repopick_substratum 463
cd frameworks/base && gcpc
croot
$repopick_substratum 464
cd frameworks/base && gcpc
croot
$repopick_substratum 465
cd frameworks/base && gcpc
croot
$repopick_substratum 466
cd frameworks/base && gcpc
croot
$repopick_substratum 467
cd frameworks/base && gcpc
croot
$repopick_substratum 468
cd frameworks/base && gcpc
croot
$repopick_substratum 455
cd frameworks/base && gcpc
croot
$repopick_substratum 469
cd frameworks/base && gcpc
croot
$repopick_substratum 470
cd frameworks/base && gcpc
croot
echo -e
