# Every Device Makefile Must Have That Makefile As An Include Otherwise You Won't Be Able To See Bootanimation While Your Device Is Booting !!
# Example USAGE 
# -include vendor/OneUI/config/bootanimation.mk


PRODUCT_PACKAGES += \
    bootanimation.zip
