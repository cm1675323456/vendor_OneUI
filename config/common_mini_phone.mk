$(call inherit-product, vendor/OneUI/config/common_mini.mk)

# Required OneUI packages
PRODUCT_PACKAGES += \
    LatinIME

$(call inherit-product, vendor/OneUI/config/telephony.mk)
