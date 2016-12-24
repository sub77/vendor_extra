# Add packages build from source
PRODUCT_PACKAGES += \
    OpenDelta

# Add prebuilt packages
PRODUCT_PACKAGES += \
    Mixplorer

# OMS
PRODUCT_PACKAGES += \
		masquerade \
		Substratum

# Updates overlay settings
PRODUCT_PACKAGE_OVERLAYS += vendor/extra/overlay/common
