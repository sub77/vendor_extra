# Remove Apollo
REMOVE_PACKAGES := \
	Apollo

PRODUCT_PACKAGES := $(filter-out $(REMOVE_PACKAGES),$(PRODUCT_PACKAGES))

# Eleven
PRODUCT_PACKAGES += \
    Eleven

# OMS
PRODUCT_PACKAGES += \
	masquerade \
	Substratum

# Add prebuilt packages
PRODUCT_PACKAGES += \
	Mixplorer

# Magisk Manager
PRODUCT_PACKAGES += \
    MagiskManager

# Copy Magisk zip
PRODUCT_COPY_FILES += \
    vendor/extra/prebuilt/common/magisk.zip:system/addon.d/magisk.zip

# init.d wifi
PRODUCT_COPY_FILES += \
    vendor/extra/prebuilt/etc/init.d/50wifi:system/etc/init.d/50wifi

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

# Custom off-mode charger
ifneq ($(WITH_CM_CHARGER),false)
PRODUCT_PACKAGES += \
    charger_res_images \
    cm_charger_res_images \
    font_log.png \
    libhealthd.cm
endif
