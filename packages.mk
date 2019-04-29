BOARD_INCLUDE_CMDLINE_TOOLS := true

########################################
############## Packages ################
########################################

# Remove Packages
REMOVE_PACKAGES := EggGame MatLog 

PRODUCT_PACKAGES := $(filter-out $(REMOVE_PACKAGES),$(PRODUCT_PACKAGES))
