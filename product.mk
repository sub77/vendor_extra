#TODO: Copy resolv.conf


########################################
############## Packages ################
########################################

# Remove Chromium and DUCertified
REMOVE_PACKAGES := \
		Chromium \
		DUCertified

PRODUCT_PACKAGES := $(filter-out $(REMOVE_PACKAGES),$(PRODUCT_PACKAGES))

# Remove SuperSU
SUPERSU := \
		vendor/du/prebuilt/common/etc/init.d/99SuperSUDaemon:system/etc/init.d/99SuperSUDaemon \
		vendor/du/prebuilt/common/UPDATE-SuperSU.zip:system/addon.d/UPDATE-SuperSU.zip

PRODUCT_COPY_FILES := $(filter-out $(SUPERSU),$(PRODUCT_COPY_FILES))

# Add wanted packages
PRODUCT_PACKAGES += \
    SlimLauncher \
		FDroid \
		Superuser \
		Catlog

# Add Superuser
# NOTE: Superuser is being named UPDATE-SuperSU.zip to keep build script happy
PRODUCT_COPY_FILES += \
		vendor/extra/prebuilt/common/Superuser.zip:system/addon.d/UPDATE-SuperSU.zip

#SUPERUSER_EMBEDDED := true

########################################
############# Settings #################
########################################

# Disable SELinux
PRODUCT_PROPERTY_OVERRIDES := $(subst selinux=1,selinux=0,$(PRODUCT_PROPERTY_OVERRIDES))

# Enable data roaming
PRODUCT_PROPERTY_OVERRIDES := $(subst dataroaming=false,dataroaming=true,$(PRODUCT_PROPERTY_OVERRIDES))

# Disable multiuser
PRODUCT_PROPERTY_OVERRIDES += fw.show_multiuserui=0

# Updates overlay settings
PRODUCT_PACKAGE_OVERLAYS += vendor/extra/overlay/common
