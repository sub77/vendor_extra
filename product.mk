########################################
############## Packages ################
########################################

# ADB
PRODUCT_COPY_FILES += \
    vendor/extra/products/common/rootdir/adbkey.pub:root/adb_keys

# Add prebuilt packages
PRODUCT_PACKAGES += \
    Mixplorer \
    Substratum

# Add wanted packages
PRODUCT_PACKAGES += \
    LockClock \
    OpenDelta

# Boot Animation
ifeq (du_falcon,$(TARGET_PRODUCT))
    PRODUCT_COPY_FILES += \
        vendor/extra/prebuilt/falcon/media/bootanimation.zip:system/media/bootanimation.zip
endif
ifneq (du_falcon,$(TARGET_PRODUCT))
    PRODUCT_COPY_FILES += \
        vendor/extra/prebuilt/common/media/bootanimation.zip:system/media/bootanimation.zip
endif

########################################
############# Settings #################
########################################

# Updates overlay settings
PRODUCT_PACKAGE_OVERLAYS += vendor/extra/overlay/common
