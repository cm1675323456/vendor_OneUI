# Inherit common OneUI stuff
$(call inherit-product, vendor/OneUI/config/common.mk)

PRODUCT_SIZE := full

# Recorder
PRODUCT_PACKAGES += \
    Recorder
