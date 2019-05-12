BOARD_INCLUDE_CMDLINE_TOOLS := true

########################################
############## Packages ################
########################################

PRODUCT_PACKAGES += \
    ViaBrowser

# Remove Packages
REMOVE_PACKAGES := \
    EggGame \
    Email \
    MatLog

PRODUCT_PACKAGES := $(filter-out $(REMOVE_PACKAGES),$(PRODUCT_PACKAGES))
