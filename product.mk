# OMS
PRODUCT_PACKAGES += \
	masquerade \
	Substratum

# Add prebuilt packages
PRODUCT_PACKAGES += \
	Mixplorer

# SuperSU
PRODUCT_COPY_FILES += \
    vendor/extra/prebuilt/common/UPDATE-SuperSU.zip:system/addon.d/UPDATE-SuperSU.zip \
    vendor/extra/prebuilt/common/etc/init.d/99SuperSUDaemon:system/etc/init.d/99SuperSUDaemon

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1
