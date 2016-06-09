#TODO: Copy resolv.conf

########################################
############## Packages ################
########################################

# Add wanted packages
PRODUCT_PACKAGES += \
		FDroid \
		Matlog \
		Snap \
		LayersManager \
		LockClock \
		htop

########################################
############# Settings #################
########################################

# Enable data roaming
PRODUCT_PROPERTY_OVERRIDES := $(subst dataroaming=false,dataroaming=true,$(PRODUCT_PROPERTY_OVERRIDES))

# Disable multiuser
PRODUCT_PROPERTY_OVERRIDES += \
		fw.show_multiuserui=0

# Enable Root for adb and apps
PRODUCT_PROPERTY_OVERRIDES += \
		persist.sys.root_access=3

# Updates overlay settings
PRODUCT_PACKAGE_OVERLAYS += vendor/extra/overlay/common
