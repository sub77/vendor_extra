########################################
############## Packages ################
########################################

# Remove Packages
REMOVE_PACKAGES :=

PRODUCT_PACKAGES := $(filter-out $(REMOVE_PACKAGES),$(PRODUCT_PACKAGES))

# Add wanted packages
PRODUCT_PACKAGES +=

########################################
############# Settings #################
########################################

PRODUCT_PROPERTY_OVERRIDES += \
    ro.debuggable=1

# Enable data roaming
PRODUCT_PROPERTY_OVERRIDES := $(subst dataroaming=false,dataroaming=true,$(PRODUCT_PROPERTY_OVERRIDES))

# Enable ADB authentication
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.adb.secure=0

# Updates overlay settings
PRODUCT_PACKAGE_OVERLAYS += vendor/extra/overlay

########################################
#############   Misc   #################
########################################

# Custom Toolchains
-include sdclang/sdclang.mk
