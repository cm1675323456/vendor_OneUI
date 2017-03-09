# Inherit common OneUI stuff
$(call inherit-product, vendor/OneUI/config/common_full.mk)

# Required OneUI packages
PRODUCT_PACKAGES += \
    LatinIME

# Include OneUI LatinIME dictionaries
PRODUCT_PACKAGE_OVERLAYS += vendor/OneUI/overlay/dictionaries
