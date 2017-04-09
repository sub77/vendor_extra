#include this into the main BoardConfig for autogenerated TW_DEVICE_VERSION
#do not echo anything back to stdout, seems to bork stuff -_-

#if TW_REC_BUILD_NUMBER_FILE is not already defined, use the current path
ifeq ($(TW_REC_BUILD_NUMBER_FILE),)
# ${CURDIR}									full path to TOP
# $(dir $(lastword $(MAKEFILE_LIST)))		relative path to this file
TW_REC_BUILD_NUMBER_FILE := "$(dir $(lastword $(MAKEFILE_LIST)))TW_REC_BUILD_NUMBER-$(TARGET_DEVICE).TXT"
endif

ifeq ($(TW_REC_MAIN_VERSION_FILE),)
# ${CURDIR}									full path to TOP
# $(dir $(lastword $(MAKEFILE_LIST)))		relative path to this file
TW_REC_MAIN_VERSION_FILE := "$(dir $(lastword $(MAKEFILE_LIST)))TW_REC_MAIN_VERSION-$(TARGET_DEVICE).TXT"
endif

TW_MAIN_VERSION_STR := $(TW_MAIN_VERSION)
export TW_MAIN_VERSION_STR
TW_DEVICE_MAINVERSION_NEW := $(TW_NEW)
export TW_DEVICE_MAINVERSION_NEW
TW_DEVICE_MAINVERSION_OLD := $(TW_OLD)
export TW_DEVICE_MAINVERSION_OLD
TW_DEVICE_VERSION := $(TW_DEV_VERSION)
export TW_DEVICE_VERSION

#testvar := "$(cat bootable/recovery/variables.h) |grep '#define TW_MAIN_VERSION_STR'|cut -d ' ' -f 9 |sed 's/[".]//g'"

#sub commands
cmd_put_out      := printf "%0d" $$build_num >$(TW_REC_BUILD_NUMBER_FILE);
cmd_putmv_out    := printf "$(TW_MAIN_VERSION_STR)" | sed 's/[.]//g' >$(TW_REC_MAIN_VERSION_FILE);
cmd_get_out      := build_str=`cat $(TW_REC_BUILD_NUMBER_FILE)`; build_num=$${build_str:0:2};
cmd_getmv_out    := mv_str=$TW_OLD;
cmd_getmvr_out   := mvr_str=$TW_NEW;
cmd_reset_mv     := echo -ne "\nTW_DEVICE_VERSION.mk: New main version, reset build number to 1\n\n" 1>&2; build_num=1;
cmd_incr_num     := build_num=$$(( 10\#$$build_num + 1 )); if [ $$build_num -gt 99 ]; then echo -ne "\nTW_DEVICE_VERSION.mk: ERROR: Build number will exceed 99 resetting to 01\n\n" 1>&2; build_num=1; fi;
cmd_is_new_mv    := `echo $(TW_NEW)` -gt $$mv_str
#cmd_is_new_mv    := `cat bootable/recovery/variables.h |grep '#define TW_MAIN_VERSION_STR'|cut -d ' ' -f 9| sed 's/"//g'| sed 's/\.//g'` -gt $$mv_str
#cmd_is_new_mv    := mytest=`cat bootable/recovery/variables.h |grep '#define TW_MAIN_VERSION_STR'|cut -d ' ' -f 9 |sed 's/[".]//g'`; $$mytest -gt $$mv_str
#cmd_is_new_mv    := echo -ne "\nTW_DEVICE_VERSION.mk: $$testvar\n\n" 1>&2; $$testvar -gt $$mv_str

#run on envsetup and/or any make
cmd_pre_run  := if [ ! -f $(TW_REC_BUILD_NUMBER_FILE) ]; then
cmd_pre_run  += 	echo "TW_DEVICE_VERSION.mk: Create Recovery build number file" 1>&2;
cmd_pre_run  += 	$(cmd_put_out)
cmd_pre_run  += fi;
cmd_pre_run  += if [ ! -f $(TW_REC_MAIN_VERSION_FILE) ]; then
cmd_pre_run  += 	echo "TW_DEVICE_VERSION.mk: Create Recovery main version file" 1>&2;
cmd_pre_run  += 	$(cmd_putmv_out)
cmd_pre_run  += fi;
cmd_pre_run  += $(cmd_getmv_out)
cmd_pre_run  += $(cmd_getmvr_out)
cmd_pre_run  += if [ $(cmd_is_new_mv) ]; then
cmd_pre_run  += 	$(cmd_reset_mv)
cmd_pre_run  += 	$(cmd_putmv_out)
cmd_pre_run  += 	$(cmd_put_out)
cmd_pre_run  += fi;

#run after: make recoveryimage
cmd_post_run := $(cmd_get_out)
cmd_post_run += $(cmd_incr_num)
cmd_post_run += $(cmd_put_out)
cmd_post_run += $(cmd_putmv_out)

#run after: make recoveryimage
cmd_post_run := $(cmd_get_out)
cmd_post_run += $(cmd_getmv_out)
cmd_post_run += if [ $(cmd_is_new_mv) ]; then
cmd_post_run += 	$(cmd_reset_mv)
cmd_post_run += else
cmd_post_run += 	$(cmd_incr_num)
cmd_post_run += fi;
cmd_post_run += $(cmd_put_out)
cmd_post_run += $(cmd_putmv_out)

#rename command
cmd_ren_rec_img  := echo -ne "\n\n\e[1mTW_DEVICE_VERSION.mk: " 1>&2;
cmd_ren_rec_img  += cp -v $(ANDROID_PRODUCT_OUT)/recovery.img $(ANDROID_PRODUCT_OUT)/twrp-$(TW_MAIN_VERSION_STR)-`cat $(TW_REC_BUILD_NUMBER_FILE)`-$(TARGET_DEVICE).img 1>&2;
#cmd_ren_rec_img  := mkdir -p /roms/upload/twrp/$(TARGET_DEVICE); cp -v "$(ANDROID_PRODUCT_OUT)/recovery.img" "/roms/upload/twrp/$(TARGET_DEVICE)/twrp-$(TW_MAIN_VERSION_STR)-`cat $(TW_REC_BUILD_NUMBER_FILE)`-$(TARGET_DEVICE).img" &>/dev/null; echo -ne "\n\n\e[1mTW_DEVICE_VERSION.mk: \e[32m$(ANDROID_PRODUCT_OUT)/twrp-$(TW_MAIN_VERSION_STR)-`cat $(TW_REC_BUILD_NUMBER_FILE)`-$(TARGET_DEVICE).img\e[0m" 1>&2;
#cmd_ren_rec_img  += mv -v "$(ANDROID_PRODUCT_OUT)/recovery.img" "$(ANDROID_PRODUCT_OUT)/twrp-$(TW_MAIN_VERSION_STR)-`cat $(TW_REC_BUILD_NUMBER_FILE)`-$(TARGET_DEVICE).img" &>/dev/null;
#cmd_ren_rec_tar  := mkdir -p /roms/upload/twrp/$(TARGET_DEVICE); cp -v "$(ANDROID_PRODUCT_OUT)/recovery.tar" "/roms/upload/twrp/$(TARGET_DEVICE)/twrp-$(TW_MAIN_VERSION_STR)-`cat $(TW_REC_BUILD_NUMBER_FILE)`-$(TARGET_DEVICE).tar" &>/dev/null; echo -ne "\n\n\e[1mTW_DEVICE_VERSION.mk: \e[32m$(ANDROID_PRODUCT_OUT)/twrp-$(TW_MAIN_VERSION_STR)-`cat $(TW_REC_BUILD_NUMBER_FILE)`-$(TARGET_DEVICE).tar\e[0m" 1>&2;
#cmd_ren_rec_tar  += mv -v "$(ANDROID_PRODUCT_OUT)/recovery.tar" "$(ANDROID_PRODUCT_OUT)/twrp-$(TW_MAIN_VERSION_STR)-`cat $(TW_REC_BUILD_NUMBER_FILE)`-$(TARGET_DEVICE).tar" &>/dev/null;

#if the build number file doesnt exist create it as 01, if it does then check date
$(shell $(cmd_pre_run))

$(shell echo "TW_DEVICE_VERSION.mk: Recovery build number=`cat $(TW_REC_BUILD_NUMBER_FILE)`" &>/dev/null)

#once the recoveryimage is built, rename the output file, and increase the build number for the next run
recoveryimage:
	$(shell $(cmd_ren_rec_img))
ifneq ($(WITH_TAR),)
	$(shell $(cmd_ren_rec_tar))
endif
	$(shell $(cmd_post_run))
	$(shell echo -ne "\n\n\e[1mTW_DEVICE_VERSION.mk:\e[0m Increase Recovery build number from $(TW_MAIN_VERSION_STR)-$(TW_DEVICE_VERSION) to $(TW_MAIN_VERSION_STR)-`cat $(TW_REC_BUILD_NUMBER_FILE)` for next build\n\n" 1>&2)


TW_DEVICE_VERSION := $(shell cat $(TW_REC_BUILD_NUMBER_FILE))
