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

# Updates overlay settings
PRODUCT_PACKAGE_OVERLAYS += vendor/extra/overlay
