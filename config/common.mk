PRODUCT_BRAND ?= OneUI

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

# Default notification/alarm sounds
PRODUCT_PROPERTY_OVERRIDES += \
    ro.config.notification_sound=Argon.ogg \
    ro.config.alarm_alert=Hassium.ogg

ifneq ($(TARGET_BUILD_VARIANT),user)
# Thank you, please drive thru!
PRODUCT_PROPERTY_OVERRIDES += persist.sys.dun.override=0
endif

ifneq ($(TARGET_BUILD_VARIANT),eng)
# Enable ADB authentication
ADDITIONAL_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

# Copy over the changelog to the device
PRODUCT_COPY_FILES += \
    vendor/OneUI/CHANGELOG.mkdn:system/etc/CHANGELOG-OneUI.txt

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/OneUI/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/OneUI/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/OneUI/prebuilt/common/bin/50-oneui.sh:system/addon.d/50-oneui.sh \
    vendor/OneUI/prebuilt/common/bin/blacklist:system/addon.d/blacklist

# Backup Services whitelist
PRODUCT_COPY_FILES += \
    vendor/OneUI/config/permissions/backup.xml:system/etc/sysconfig/backup.xml

# Signature compatibility validation
PRODUCT_COPY_FILES += \
    vendor/OneUI/prebuilt/common/bin/otasigcheck.sh:install/bin/otasigcheck.sh

# init.d support
PRODUCT_COPY_FILES += \
    vendor/OneUI/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/OneUI/prebuilt/common/bin/sysinit:system/bin/sysinit

ifneq ($(TARGET_BUILD_VARIANT),user)
# userinit support
PRODUCT_COPY_FILES += \
    vendor/OneUI/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit
endif

# ONEUI-specific init file
PRODUCT_COPY_FILES += \
    vendor/OneUI/prebuilt/common/etc/init.local.rc:root/init.cm.rc

# Copy over added mimetype supported in libcore.net.MimeUtils
PRODUCT_COPY_FILES += \
    vendor/OneUI/prebuilt/common/lib/content-types.properties:system/lib/content-types.properties

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl

# This is ONEUI!
PRODUCT_COPY_FILES += \
    vendor/OneUI/config/permissions/com.oneui.android.xml:system/etc/permissions/com.oneui.android.xml

# Include ONEUI audio files
include vendor/OneUI/config/oneui_audio.mk

# Theme engine
include vendor/OneUI/config/themes_common.mk

ifneq ($(TARGET_DISABLE_CMSDK), true)
# CMSDK
include vendor/OneUI/config/cmsdk_common.mk
endif

# Bootanimation
PRODUCT_PACKAGES += \
    bootanimation.zip

# Required ONEUI packages
PRODUCT_PACKAGES += \
    BluetoothExt \
    CMAudioService \
    CMParts \
    Development \
    Profiles \
    WeatherManagerService

# Optional ONEUI packages
PRODUCT_PACKAGES += \
    libemoji \
    LiveWallpapersPicker \
    PhotoTable 

# Include explicitly to work around GMS issues
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full \
    librsjni

# Custom ONEUI packages
PRODUCT_PACKAGES += \
    AudioFX \
    CMSettingsProvider \
    LineageSetupWizard \
    Eleven \
    ExactCalculator \
    LiveLockScreenService \
    LockClock \
    Trebuchet \
    WeatherProvider

# Exchange support
PRODUCT_PACKAGES += \
    Exchange2

# Extra tools in ONEUI
PRODUCT_PACKAGES += \
    7z \
    bash \
    bzip2 \
    curl \
    fsck.ntfs \
    gdbserver \
    htop \
    lib7z \
    libsepol \
    micro_bench \
    mke2fs \
    mkfs.ntfs \
    mount.ntfs \
    oprofiled \
    pigz \
    powertop \
    sqlite3 \
    strace \
    tune2fs \
    unrar \
    unzip \
    vim \
    wget \
    zip

# Custom off-mode charger
ifneq ($(WITH_CM_CHARGER),false)
PRODUCT_PACKAGES += \
    charger_res_images \
    cm_charger_res_images \
    font_log.png \
    libhealthd.cm
endif

# ExFAT support
WITH_EXFAT ?= true
ifeq ($(WITH_EXFAT),true)
TARGET_USES_EXFAT := true
PRODUCT_PACKAGES += \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat
endif

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

# rsync
PRODUCT_PACKAGES += \
    rsync

# Stagefright FFMPEG plugin
PRODUCT_PACKAGES += \
    libffmpeg_extractor \
    libffmpeg_omx \
    media_codecs_ffmpeg.xml

PRODUCT_PROPERTY_OVERRIDES += \
    media.sf.omx-plugin=libffmpeg_omx.so \
    media.sf.extractor-plugin=libffmpeg_extractor.so

# Storage manager
PRODUCT_PROPERTY_OVERRIDES += \
    ro.storage_manager.enabled=true

# Telephony
PRODUCT_PACKAGES += \
    telephony-ext

PRODUCT_BOOT_JARS += \
    telephony-ext

# These packages are excluded from user builds
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_PACKAGES += \
    procmem \
    procrank \
    su
endif

DEVICE_PACKAGE_OVERLAYS += vendor/OneUI/overlay/common


PRODUCT_VERSION_MAJOR = 7
PRODUCT_VERSION_MINOR = 1
PRODUCT_VERSION_MAINTENANCE := 0

ifeq ($(TARGET_VENDOR_SHOW_MAINTENANCE_VERSION),true)
    ONEUI_VERSION_MAINTENANCE := $(PRODUCT_VERSION_MAINTENANCE)
else
    ONEUI_VERSION_MAINTENANCE := 0
endif

# Set ONEUI_BUILDTYPE from the env RELEASE_TYPE, for jenkins compat

ifndef ONEUI_BUILDTYPE
    ifdef RELEASE_TYPE
        # Starting with "ONEUI_" is optional
        RELEASE_TYPE := $(shell echo $(RELEASE_TYPE) | sed -e 's|^ONEUI_||g')
        ONEUI_BUILDTYPE := $(RELEASE_TYPE)
    endif
endif

# Filter out random types, so it'll reset to UNOFFICIAL
ifeq ($(filter RELEASE NIGHTLY SNAPSHOT EXPERIMENTAL,$(ONEUI_BUILDTYPE)),)
    ONEUI_BUILDTYPE :=
endif

ifdef ONEUI_BUILDTYPE
    ifneq ($(ONEUI_BUILDTYPE), SNAPSHOT)
        ifdef ONEUI_EXTRAVERSION
            # Force build type to EXPERIMENTAL
            ONEUI_BUILDTYPE := EXPERIMENTAL
            # Remove leading dash from ONEUI_EXTRAVERSION
            ONEUI_EXTRAVERSION := $(shell echo $(ONEUI_EXTRAVERSION) | sed 's/-//')
            # Add leading dash to ONEUI_EXTRAVERSION
            ONEUI_EXTRAVERSION := -$(ONEUI_EXTRAVERSION)
        endif
    else
        ifndef ONEUI_EXTRAVERSION
            # Force build type to EXPERIMENTAL, SNAPSHOT mandates a tag
            ONEUI_BUILDTYPE := EXPERIMENTAL
        else
            # Remove leading dash from ONEUI_EXTRAVERSION
            ONEUI_EXTRAVERSION := $(shell echo $(ONEUI_EXTRAVERSION) | sed 's/-//')
            # Add leading dash to ONEUI_EXTRAVERSION
            ONEUI_EXTRAVERSION := -$(ONEUI_EXTRAVERSION)
        endif
    endif
else
    # If ONEUI_BUILDTYPE is not defined, set to UNOFFICIAL
    ONEUI_BUILDTYPE := UNOFFICIAL
    ONEUI_EXTRAVERSION :=
endif

ifeq ($(ONEUI_BUILDTYPE), UNOFFICIAL)
    ifneq ($(TARGET_UNOFFICIAL_BUILD_ID),)
        ONEUI_EXTRAVERSION := -$(TARGET_UNOFFICIAL_BUILD_ID)
    endif
endif

ifeq ($(ONEUI_BUILDTYPE), RELEASE)
    ifndef TARGET_VENDOR_RELEASE_BUILD_ID
        ONEUI_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)$(PRODUCT_VERSION_DEVICE_SPECIFIC)-$(ONEUI_BUILD)
    else
        ifeq ($(TARGET_BUILD_VARIANT),user)
            ifeq ($(ONEUI_VERSION_MAINTENANCE),0)
                ONEUI_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(TARGET_VENDOR_RELEASE_BUILD_ID)-$(ONEUI_BUILD)
            else
                ONEUI_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(ONEUI_VERSION_MAINTENANCE)-$(TARGET_VENDOR_RELEASE_BUILD_ID)-$(ONEUI_BUILD)
            endif
        else
            ONEUI_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)$(PRODUCT_VERSION_DEVICE_SPECIFIC)-$(ONEUI_BUILD)
        endif
    endif
else
    ifeq ($(ONEUI_VERSION_MAINTENANCE),0)
        ONEUI_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(shell date -u +%Y%m%d)-$(ONEUI_BUILDTYPE)$(ONEUI_EXTRAVERSION)-$(ONEUI_BUILD)
    else
        ONEUI_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(ONEUI_VERSION_MAINTENANCE)-$(shell date -u +%Y%m%d)-$(ONEUI_BUILDTYPE)$(ONEUI_EXTRAVERSION)-$(ONEUI_BUILD)
    endif
endif

PRODUCT_PROPERTY_OVERRIDES += \
    ro.oneui.version=$(ONEUI_VERSION) \
    ro.oneui.releasetype=$(ONEUI_BUILDTYPE) \
    ro.modversion=$(ONEUI_VERSION) \
    ro.oneuilegal.url=https://lineageos.org/legal

PRODUCT_EXTRA_RECOVERY_KEYS += \
    vendor/OneUI/build/target/product/security/oneui

-include vendor/OneUI-priv/keys/keys.mk

ONEUI_DISPLAY_VERSION := $(ONEUI_VERSION)

ifneq ($(PRODUCT_DEFAULT_DEV_CERTIFICATE),)
ifneq ($(PRODUCT_DEFAULT_DEV_CERTIFICATE),build/target/product/security/testkey)
    ifneq ($(ONEUI_BUILDTYPE), UNOFFICIAL)
        ifndef TARGET_VENDOR_RELEASE_BUILD_ID
            ifneq ($(ONEUI_EXTRAVERSION),)
                # Remove leading dash from ONEUI_EXTRAVERSION
                ONEUI_EXTRAVERSION := $(shell echo $(ONEUI_EXTRAVERSION) | sed 's/-//')
                TARGET_VENDOR_RELEASE_BUILD_ID := $(ONEUI_EXTRAVERSION)
            else
                TARGET_VENDOR_RELEASE_BUILD_ID := $(shell date -u +%Y%m%d)
            endif
        else
            TARGET_VENDOR_RELEASE_BUILD_ID := $(TARGET_VENDOR_RELEASE_BUILD_ID)
        endif
        ifeq ($(ONEUI_VERSION_MAINTENANCE),0)
            ONEUI_DISPLAY_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR)-$(TARGET_VENDOR_RELEASE_BUILD_ID)-$(ONEUI_BUILD)
        else
            ONEUI_DISPLAY_VERSION := $(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(ONEUI_VERSION_MAINTENANCE)-$(TARGET_VENDOR_RELEASE_BUILD_ID)-$(ONEUI_BUILD)
        endif
    endif
endif
endif

PRODUCT_PROPERTY_OVERRIDES += \
    ro.oneui.display.version=$(ONEUI_DISPLAY_VERSION)

-include $(WORKSPACE)/build_env/image-auto-bits.mk
-include vendor/OneUI/config/partner_gms.mk
-include vendor/cyngn/product.mk

$(call prepend-product-if-exists, vendor/extra/product.mk)
