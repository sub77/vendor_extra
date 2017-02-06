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

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1
