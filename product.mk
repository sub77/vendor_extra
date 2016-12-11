# Add packages build from source
PRODUCT_PACKAGES += \
    OpenDelta

# Add prebuilt packages
PRODUCT_PACKAGES += \
    Substratum \
    Mixplorer

# Updates overlay settings
PRODUCT_PACKAGE_OVERLAYS += vendor/extra/overlay/common
