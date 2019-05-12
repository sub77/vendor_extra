BOARD_INCLUDE_CMDLINE_TOOLS := true

TARGET_USES_AOSP_BROWSER := true

########################################
############## Packages ################
########################################

PRODUCT_PACKAGES += \
    ViaBrowser

# Remove Packages
REMOVE_PACKAGES := \
    EggGame \
    MatLog

PRODUCT_PACKAGES := $(filter-out $(REMOVE_PACKAGES),$(PRODUCT_PACKAGES))
