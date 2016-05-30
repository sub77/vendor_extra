#TODO: Copy resolv.conf

# XXX: Remove when merged into /vendor/slim
# https://review.slimroms.org/#/c/15890/
#
## SLim Framework
include frameworks/opt/slim/slim_framework.mk

########################################
############## Packages ################
########################################

# Add wanted packages
PRODUCT_PACKAGES += \
		FDroid \
		Matlog \
		Snap

########################################
############# Settings #################
########################################

# Enable data roaming
PRODUCT_PROPERTY_OVERRIDES := $(subst dataroaming=false,dataroaming=true,$(PRODUCT_PROPERTY_OVERRIDES))

# Disable multiuser
PRODUCT_PROPERTY_OVERRIDES += \
		fw.show_multiuserui=0

# Updates overlay settings
PRODUCT_PACKAGE_OVERLAYS += vendor/extra/overlay/common
