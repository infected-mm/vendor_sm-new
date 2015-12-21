# Copyright (C) 2014-2015 The SaberMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Written for SaberMod toolchains
# TARGET_SM_AND and TARGET_SM_KERNEL can be set before this file, to override the default of gcc 4.9 for ROM.
# This is to avoid hardcoding the gcc versions for the ROM and kernels.

# Inherit sabermod configs.  Default to arm if LOCAL_ARCH is not defined.

ifdef TARGET_SM_AND
export TARGET_SM_AND := $(TARGET_SM_AND)
else
  $(warning !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!)
  $(warning TARGET_SM_AND not defined.)
  $(warning Defaulting to gcc 4.9 for ROM.)
  $(warning !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!)
export TARGET_SM_AND := 4.9
endif

ifdef TARGET_SM_KERNEL
  export TARGET_SM_KERNEL := $(TARGET_SM_KERNEL)
else
  $(warning !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!)
  $(warning TARGET_SM_KERNEL not defined.)
  $(warning Defaulting to ROM gcc version $(TARGET_SM_AND).)
  $(warning !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!)
  export TARGET_SM_KERNEL := $(TARGET_SM_AND)
endif

# Set GCC colors
export GCC_COLORS := 'error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

ifndef LOCAL_ARCH
  $(warning !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!)
  $(warning Can not determine arch type, defaulting to arm)
  $(warning  To change this set LOCAL_ARCH :=)
  $(warning !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!)
  LOCAL_ARCH := arm
endif

# Enable SaberMod ARM Mode for all arm builds.
ifneq ($(filter arm arm64,$(LOCAL_ARCH)),)
  ifneq ($(ENABLE_SABERMOD_ARM_MODE),false)
    ENABLE_SABERMOD_ARM_MODE := true
    OPT4 := [gcc-arm]
  endif
endif

ifeq ($(strip $(LOCAL_ARCH)),arm)

  # Strict aliasing
  ifeq ($(strip $(LOCAL_STRICT_ALIASING)),true)
    GCC_STRICT_FLAGS := -Wstrict-aliasing=3 -Werror=strict-aliasing
    CLANG_STRICT_FLAGS := -Wstrict-aliasing=2 -Werror=strict-aliasing
  endif
endif

# Bluetooth modules
LOCAL_BLUETOOTH_BLUEDROID := \
  bluetooth.default \
  libbt-brcm_stack \
  audio.a2dp.default \
  libbt-brcm_gki \
  libbt-utils \
  libbt-qcom_sbc_decoder \
  libbt-brcm_bta \
  bdt \
  bdtest \
  libbt-hci \
  libosi \
  ositests \
  libbt-vendor \
  libbluetooth_jni

ifndef NO_OPTIMIZATIONS
  NO_OPTIMIZATIONS := $(LOCAL_BLUETOOTH_BLUEDROID)
else
  NO_OPTIMIZATIONS += $(LOCAL_BLUETOOTH_BLUEDROID)
endif

ifeq ($(strip $(LOCAL_ARCH)),arm64)

  # Strict aliasing
  ifeq ($(strip $(LOCAL_STRICT_ALIASING)),true)
    GCC_STRICT_FLAGS := -fstrict-aliasing -Wstrict-aliasing=3 -Werror=strict-aliasing
    CLANG_STRICT_FLAGS := -fstrict-aliasing -Wstrict-aliasing=2 -Werror=strict-aliasing
  endif
endif

# Turn debugging off for all builds.
FORCE_DISABLE_DEBUGGING := true

ifneq ($(filter arm arm64,$(LOCAL_ARCH)),)
  ifeq ($(strip $(LOCAL_ARCH)),arm)

    ifneq (,$(filter 5.% 6.%,$(TARGET_SM_AND)))
      ifndef TARGET_SECOND_SM_AND

        # Needs required 4.9 toolchain libs for hybrid gcc mode.
        TARGET_SECOND_SM_AND := 4.9
      endif
      ifndef TARGET_NDK_VERSION

        # Default to GCC 4.9 version for the NDK libs and includes.
        TARGET_NDK_VERSION := 4.9
      endif
    endif

    ifeq (,$(filter 5.% 6.%,$(TARGET_SM_AND)))
export TARGET_ARCH_LIB_PATH := $(ANDROID_BUILD_TOP)/prebuilts/gcc/$(HOST_PREBUILT_TAG)/arm/arm-linux-androideabi-$(TARGET_SM_AND)/lib
export TARGET_ARCH_INC_PATH := $(ANDROID_BUILD_TOP)/prebuilts/gcc/$(HOST_PREBUILT_TAG)/arm/arm-linux-androideabi-$(TARGET_SM_AND)/include
    else
export TARGET_ARCH_LIB_PATH := $(ANDROID_BUILD_TOP)/prebuilts/gcc/$(HOST_PREBUILT_TAG)/arm/arm-linux-androideabi-$(TARGET_SM_AND)/lib
export TARGET_ARCH_SECOND_LIB_PATH := $(ANDROID_BUILD_TOP)/prebuilts/gcc/$(HOST_PREBUILT_TAG)/arm/arm-linux-androideabi-$(TARGET_SECOND_SM_AND)/lib
export TARGET_ARCH_INC_PATH := $(ANDROID_BUILD_TOP)/prebuilts/gcc/$(HOST_PREBUILT_TAG)/arm/arm-linux-androideabi-$(TARGET_SM_AND)/include
export TARGET_ARCH_SECOND_INC_PATH := $(ANDROID_BUILD_TOP)/prebuilts/gcc/$(HOST_PREBUILT_TAG)/arm/arm-linux-androideabi-$(TARGET_SECOND_SM_AND)/include
    endif

    # Path to ROM toolchain
    SM_AND_PATH := prebuilts/gcc/$(HOST_PREBUILT_TAG)/arm/arm-linux-androideabi-$(TARGET_SM_AND)
    SM_AND := $(shell cat $(SM_AND_PATH)/VERSION)

    # Find strings in version info
    ifneq ($(filter %sabermod,$(SM_AND)),)
export SM_AND_NAME := $(filter %sabermod,$(SM_AND))
      SM_AND_DATE := $(filter 20140% 20141% 20150% 20151%,$(SM_AND))
      SM_AND_STATUS := $(filter (release) (prerelease) (experimental),$(SM_AND))
      SM_AND_VERSION := $(SM_AND_NAME)-$(SM_AND_DATE)-$(SM_AND_STATUS)

      # Write version info to build.prop
      PRODUCT_PROPERTY_OVERRIDES += \
        ro.sm.android=$(SM_AND_VERSION)
        
      # Graphite ROM flags
      OPT1 := [graphite]

      # Some graphite flags are only available for certain gcc versions
export GRAPHITE_UNROLL_AND_JAM_AND := $(filter 5.% 6.%,$(SM_AND_NAME))

      # Graphite flags and friends
      BASE_GRAPHITE_FLAGS := \
        -fgraphite \
        -fgraphite-identity \
        -floop-flatten \
        -ftree-loop-linear \
        -floop-interchange \
        -floop-strip-mine \
        -floop-block

      # Check if there's already something set somewhere.
      ifndef GRAPHITE_FLAGS
        GRAPHITE_FLAGS := \
          $(BASE_GRAPHITE_FLAGS)
      else
        GRAPHITE_FLAGS += \
          $(BASE_GRAPHITE_FLAGS)
      endif

      # Legacy gcc doesn't understand this flag
      ifneq ($(strip $(USE_LEGACY_GCC)),true)
        GRAPHITE_FLAGS += \
          -Wno-error=maybe-uninitialized
      endif
    endif

    # Path to kernel toolchain
    SM_KERNEL_PATH := prebuilts/gcc/$(HOST_PREBUILT_TAG)/arm/arm-eabi-$(TARGET_SM_KERNEL)
    SM_KERNEL := $(shell $(SM_KERNEL_PATH)/bin/arm-eabi-gcc --version)

    ifneq ($(filter %sabermod,$(SM_KERNEL)),)
export SM_KERNEL_NAME := $(filter %sabermod,$(SM_KERNEL))
      SM_KERNEL_DATE := $(filter 20140% 20141% 20150% 20151%,$(SM_KERNEL))
      SM_KERNEL_STATUS := $(filter (release) (prerelease) (experimental),$(SM_KERNEL))
      SM_KERNEL_VERSION := $(SM_KERNEL_NAME)-$(SM_KERNEL_DATE)-$(SM_KERNEL_STATUS)

      # Graphite flags for kernel

      # Some graphite flags are only available for certain gcc versions
export GRAPHITE_UNROLL_AND_JAM_KERNEL := $(filter 5.% 6.%,$(SM_KERNEL_NAME))

      BASE_GRAPHITE_KERNEL_FLAGS := \
        -fgraphite \
        -fgraphite-identity \
        -floop-flatten \
        -ftree-loop-linear \
        -floop-interchange \
        -floop-strip-mine \
        -floop-block
      ifneq ($(GRAPHITE_UNROLL_AND_JAM_KERNEL),)
        BASE_GRAPHITE_KERNEL_FLAGS += \
          -floop-unroll-and-jam
      endif

      # Check if there's already something set somewhere.
      ifndef GRAPHITE_KERNEL_FLAGS
 export GRAPHITE_KERNEL_FLAGS := \
          $(BASE_GRAPHITE_KERNEL_FLAGS)
      else
 export GRAPHITE_KERNEL_FLAGS := \
          $(BASE_GRAPHITE_KERNEL_FLAGS) \
          $(GRAPHITE_KERNEL_FLAGS)
      endif

      ifneq ($(filter 5.% 6.%,$(SM_KERNEL_NAME)),)

        # Flags to disable graphite in the kernel for gcc 5/6
 export LOCAL_DISABLE_KERNEL_GRAPHITE := \
          -fno-graphite \
          -fno-graphite-identity \
          -fno-loop-flatten \
          -fno-tree-loop-linear \
          -fno-loop-interchange \
          -fno-loop-strip-mine \
          -fno-loop-block \
          -fno-loop-nest-optimize \
          -fno-loop-unroll-and-jam \
          -fno-loop-parallelize-all \
          -ftree-parallelize-loops=0 \
          -fno-openmp
      endif

      ifeq ($(strip $(LOCAL_STRICT_ALIASING)),true)

        # strict-aliasing kernel flags
 export KERNEL_STRICT_FLAGS := \
          -fstrict-aliasing \
          -Werror=strict-aliasing
      endif
export TARGET_ARCH_KERNEL_LIB_PATH := $(ANDROID_BUILD_TOP)/prebuilts/gcc/$(HOST_PREBUILT_TAG)/arm/arm-eabi-$(TARGET_SM_KERNEL)/lib
export TARGET_ARCH_KERNEL_INC_PATH := $(ANDROID_BUILD_TOP)/prebuilts/gcc/$(HOST_PREBUILT_TAG)/arm/arm-eabi-$(TARGET_SM_KERNEL)/include
    endif

    # GCC Defaults or CPU Tuning.
    ifneq ($(ENABLE_GCC_DEFAULTS),true)
      LOCAL_DISABLE_TUNE := \
	libc_dns \
	libc_tzcode \
	bluetooth.default \
	libwebviewchromium \
	libwebviewchromium_loader \
	libwebviewchromium_plat_support \
	$(NO_OPTIMIZATIONS)
      OPT8 := [cpu-tune]
    else
      export ENABLE_GCC_DEFAULTS := true
      USE_GCC_DEFAULTS := -march=armv7-a -mtune=cortex-a15
      OPT8 := [gcc-defaults]
    endif

    # GCC hybrid mode.
    ifneq (,$(filter 5.% 6.%,$(SM_AND_NAME)))
      GCC_4_9_MODULES_BASE := \
        libcutils \
        libbccRenderscript \
        libbcinfo \
        libbccCore \
        libbccExecutionEngine \
        libbccSupport \
        librsloader \
        bcc \
        dalvikvm \
        libbacktrace_libc++ \
        base_base_gyp \
        libart \
        dex2oat \
        libvixl \
        libart-compiler \
        libaudioresampler \
        libart-disassembler \
        oatdump \
        patchoat
      ifndef GCC_4_9_MODULES
        GCC_4_9_MODULES := $(GCC_4_9_MODULES_BASE)
      else
        GCC_4_9_MODULES += $(GCC_4_9_MODULES_BASE)
      endif
    endif
  endif

  ifeq ($(strip $(LOCAL_ARCH)),arm64)

export TARGET_ARCH_LIB_PATH := $(ANDROID_BUILD_TOP)/prebuilts/gcc/$(HOST_PREBUILT_TAG)/aarch64/aarch64-linux-android-$(TARGET_SM_AND)/lib

    # Path to toolchain
    SM_AND_PATH := prebuilts/gcc/$(HOST_PREBUILT_TAG)/aarch64/aarch64-linux-android-$(TARGET_SM_AND)
    SM_AND := $(shell cat $(SM_AND_PATH)/VERSION)

    # Find strings in version info
    ifneq ($(filter %sabermod,$(SM_AND)),)
export SM_AND_NAME := $(filter %sabermod,$(SM_AND))
      SM_AND_DATE := $(filter 20140% 20141% 20150% 20151%,$(SM_AND))
      SM_AND_STATUS := $(filter (release) (prerelease) (experimental),$(SM_AND))
      SM_AND_VERSION := $(SM_AND_NAME)-$(SM_AND_DATE)-$(SM_AND_STATUS)

      # Write version info to build.prop
      PRODUCT_PROPERTY_OVERRIDES += \
        ro.sm.android=$(SM_AND_VERSION)

      # Graphite ROM flags
      OPT1 := [graphite]

      # Some graphite flags are only available for certain gcc versions
export GRAPHITE_UNROLL_AND_JAM_AND := $(filter 5.% 6.%,$(SM_AND_NAME))

      # Graphite flags and friends
      BASE_GRAPHITE_FLAGS := \
        -fgraphite \
        -fgraphite-identity \
        -floop-flatten \
        -ftree-loop-linear \
        -floop-interchange \
        -floop-strip-mine \
        -floop-block

      # Check if there's already something set somewhere.
      ifndef GRAPHITE_FLAGS
        GRAPHITE_FLAGS := \
          $(BASE_GRAPHITE_FLAGS)
      else
        GRAPHITE_FLAGS += \
          $(BASE_GRAPHITE_FLAGS)
      endif

      # Legacy gcc doesn't understand this flag
      ifneq ($(strip $(USE_LEGACY_GCC)),true)
        GRAPHITE_FLAGS += \
          -Wno-error=maybe-uninitialized
      endif
    endif
  
    # Path to kernel toolchain
    SM_KERNEL_PATH := prebuilts/gcc/$(HOST_PREBUILT_TAG)/aarch64/aarch64-$(TARGET_SM_KERNEL)
    SM_KERNEL := $(shell $(SM_KERNEL_PATH)/bin/aarch64-gcc --version)

    ifneq ($(filter %sabermod,$(SM_KERNEL)),)
export SM_KERNEL_NAME := $(filter %sabermod,$(SM_KERNEL))
      SM_KERNEL_DATE := $(filter 20140% 20141% 20150% 20151%,$(SM_KERNEL))
      SM_KERNEL_STATUS := $(filter (release) (prerelease) (experimental),$(SM_KERNEL))
      SM_KERNEL_VERSION := $(SM_KERNEL_NAME)-$(SM_KERNEL_DATE)-$(SM_KERNEL_STATUS)

      # Graphite flags for kernel

      # Some graphite flags are only available for certain gcc versions
export GRAPHITE_UNROLL_AND_JAM_KERNEL := $(filter 5.% 6.%,$(SM_KERNEL_NAME))

      BASE_GRAPHITE_KERNEL_FLAGS := \
        -fgraphite \
        -fgraphite-identity \
        -floop-flatten \
        -ftree-loop-linear \
        -floop-interchange \
        -floop-strip-mine \
        -floop-block
      ifneq ($(GRAPHITE_UNROLL_AND_JAM_KERNEL),)
        BASE_GRAPHITE_KERNEL_FLAGS += \
          -floop-unroll-and-jam
      endif

      # Check if there's already something set somewhere.
      ifndef GRAPHITE_KERNEL_FLAGS
 export GRAPHITE_KERNEL_FLAGS := \
          $(BASE_GRAPHITE_KERNEL_FLAGS)
      else
 export GRAPHITE_KERNEL_FLAGS := \
          $(BASE_GRAPHITE_KERNEL_FLAGS) \
          $(GRAPHITE_KERNEL_FLAGS)
      endif

      ifneq ($(filter 5.% 6.%,$(SM_KERNEL_NAME)),)
        # Flags to disable graphite in the kernel for gcc 5/6
 export LOCAL_DISABLE_KERNEL_GRAPHITE := \
          -fno-graphite \
          -fno-graphite-identity \
          -fno-loop-flatten \
          -fno-tree-loop-linear \
          -fno-loop-interchange \
          -fno-loop-strip-mine \
          -fno-loop-block \
          -fno-loop-nest-optimize \
          -fno-loop-unroll-and-jam \
          -fno-loop-parallelize-all \
          -ftree-parallelize-loops=0 \
          -fno-openmp
      endif

      ifeq ($(strip $(LOCAL_STRICT_ALIASING)),true)

      # strict-aliasing kernel flags
export KERNEL_STRICT_FLAGS := \
        -fstrict-aliasing \
        -Werror=strict-aliasing
      endif
    endif
export TARGET_ARCH_LIB_PATH := $(ANDROID_BUILD_TOP)/prebuilts/gcc/$(HOST_PREBUILT_TAG)/aarch64/aarch64-$(TARGET_SM_KERNEL)/lib:$(TARGET_ARCH_LIB_PATH)
  endif
  ifdef TARGET_ARCH_LIB_PATH

    # Add extra libs for the compilers to use
export LD_LIBRARY_PATH := $(TARGET_ARCH_LIB_PATH):$(LD_LIBRARY_PATH)
export LIBRARY_PATH := $(TARGET_ARCH_LIB_PATH):$(LIBRARY_PATH)
  endif

  ifneq ($(GRAPHITE_FLAGS),)

    # Force disable some modules that are not compatible with graphite flags.
    # Add more modules if needed for devices in device/sm_device.mk or by ROM in product/rom_product.mk with
    # LOCAL_DISABLE_GRAPHITE:=

    ifneq ($(filter 4.8% 4.9%,$(SM_AND_NAME)),)
      LOCAL_BASE_DISABLE_GRAPHITE := \
        libunwind \
        libFFTEm \
        libicui18n \
        libskia \
        libvpx \
        libmedia_jni \
        libstagefright_mp3dec \
        libart \
        mdnsd \
        libwebrtc_spl \
        third_party_WebKit_Source_core_webcore_svg_gyp \
        libjni_filtershow_filters \
        libavformat \
        libavcodec \
        skia_skia_library_gyp \
        libSR_Core \
        third_party_libvpx_libvpx_gyp \
        ui_gl_gl_gyp \
        fio \
        libpdfiumcore \
        libFraunhoferAAC \
        libinput \
        libmedia \
	$(NO_OPTIMIZATIONS)
    endif

    ifneq ($(filter 5.% 6.%,$(SM_AND_NAME)),)
      LOCAL_BASE_DISABLE_GRAPHITE := \
        libjavacore \
        libc_bionic \
        libnetutils \
        libandroid_runtime \
        libpdfiumcore \
        libicui18n \
        libicuuc \
        libhwui \
        libskia \
        dhcpcd \
        libpac \
        libRS \
        clatd \
        libsoftkeymaster \
        libstagefright_avc_common \
        libstagefright_color_conversion \
        libstagefright_matroska \
        libwebm \
        libstagefright_amrnb_common \
        libart \
        libart-compiler \
        libjavacrypto \
        libstagefright_omx \
        libstagefright_amrnbdec \
        librtp_jni \
        libstagefright_amrnbenc \
        libFraunhoferAAC \
        audio.r_submix.default \
        liboverlay \
        libmedia_jni \
        libstagefright_amrwbdec \
        libstagefright_avcenc \
        libstagefright_mp3dec \
        libstagefright_m4vh263dec \
        libstagefright_m4vh263enc \
        libwebrtc_apm \
        busybox \
	$(NO_OPTIMIZATIONS)
    endif

    # Check if there's already something set somewhere.
    ifndef LOCAL_DISABLE_GRAPHITE
      LOCAL_DISABLE_GRAPHITE := \
        $(LOCAL_BASE_DISABLE_GRAPHITE)
    else
      LOCAL_DISABLE_GRAPHITE += \
        $(LOCAL_BASE_DISABLE_GRAPHITE)
    endif
  endif
endif

# strict-aliasing

ifeq ($(strip $(LOCAL_STRICT_ALIASING)),true)
  LOCAL_BASE_DISABLE_STRICT_ALIASING := \
    libpdfiumcore \
    libpdfium \
    libc_bionic \
    libc_dns \
    libc_gdtoa \
    libc_openbsd \
    libfs_mgr \
    libcutils \
    liblog \
    libc \
    adbd \
    libunwind \
    libziparchive \
    libsync \
    libnetutils \
    libRS \
    libbcinfo \
    libbccCore \
    libbccSupport \
    libstagefright_foundation \
    libusbhost \
    bluetooth.default \
    libbt-brcm_bta \
    libnetd_client \
    libbt-brcm_stack \
    bcc \
    debuggerd \
    toolbox \
    clatd \
    ip \
    libnetlink \
    libc_nomalloc \
    linker \
    libstagefright_avc_common \
    logd \
    libstagefright_webm \
    libstagefright_httplive \
    libstagefright_rtsp \
    sdcard \
    netd \
    libdiskconfig \
    audio.a2dp.default \
    libjavacore \
    libstagefright_avcenc \
    libRSDriver \
    libc_malloc \
    libRSSupport \
    libstlport \
    libandroid_runtime \
    libcrypto \
    libwnndict \
    libmedia \
    dnsmasq \
    ping \
    ping6 \
    libaudioflinger \
    libmediaplayerservice \
    libstagefright \
    libvariablespeed \
    librtp_jni \
    libwilhelm \
    libdownmix \
    libldnhncr \
    libqcomvisualizer \
    libvisualizer \
    libandroidfw \
    libstlport_static \
    tcpdump \
    $(NO_OPTIMIZATIONS)

  # Check if there's already something somewhere.
  ifndef LOCAL_DISABLE_STRICT_ALIASING
    LOCAL_DISABLE_STRICT_ALIASING := \
      $(LOCAL_BASE_DISABLE_STRICT_ALIASING)
  else
    LOCAL_DISABLE_STRICT_ALIASING += \
      $(LOCAL_BASE_DISABLE_STRICT_ALIASING)
  endif
  OPT5 := [strict]
else
  OPT5 :=
endif

# General flags for gcc 4.9 to allow compilation to complete.
# Commented out for now since there's no common (non-device specific) modules to list here.
# Add more modules if needed for devices in device/sm_device.mk or by ROM in product/rom_product.mk with
# MAYBE_UNINITIALIZED :=

# Check if there's already something set somewhere.
ifndef MAYBE_UNINITIALIZED
  MAYBE_UNINITIALIZED := \
    fastboot
else
  MAYBE_UNINITIALIZED += \
    fastboot
endif

# O3 optimizations
ifeq ($(strip $(LOCAL_O3)),true)

  # Export to the kernel
  export LOCAL_O3 := true

  # If -O3 is enabled, force disable on thumb flags.
  # loop optmizations are not really usefull in thumb mode.
  LOCAL_DISABLE_O3_THUMB := true
  OPT2 := [O3]

  # Disable some modules that break with -O3
  # Add more modules if needed for devices in device/sm_device.mk or by ROM in product/rom_product.mk with
  # LOCAL_DISABLE_O3 :=

  # Check if there's already something set somewhere.
  ifndef LOCAL_DISABLE_O3
    LOCAL_DISABLE_O3 := \
      libaudioflinger \
      skia_skia_library_gyp \
      $(NO_OPTIMIZATIONS)
  else
    LOCAL_DISABLE_O3 += \
      libaudioflinger \
      skia_skia_library_gyp \
      $(NO_OPTIMIZATIONS)
  endif

  # -O3 flags and friends
  O3_FLAGS := \
    -O3 \
    -Wno-error=array-bounds \
    -Wno-error=strict-overflow
else
    OPT2:=
endif

ifeq (true,$(strip $(DISABLE_O3_KERNEL)))

  # Export to the kernel
export DISABLE_O3_KERNEL := true
endif

# Extra SaberMod GCC loop flags.
export EXTRA_SABERMOD_GCC := \
         -ftree-loop-distribution \
         -ftree-loop-if-convert \
         -ftree-loop-im \
         -ftree-loop-ivcanon

EXTRA_SABERMOD_HOST_GCC := \
  -ftree-loop-distribution \
  -ftree-loop-if-convert \
  -ftree-loop-im \
  -ftree-loop-ivcanon

ifdef EXTRA_SABERMOD_GCC_VECTORIZE
export EXTRA_SABERMOD_GCC_VECTORIZE := \
         $(EXTRA_SABERMOD_GCC_VECTORIZE) \
         -ftree-vectorize
else
export EXTRA_SABERMOD_GCC_VECTORIZE := \
         -ftree-vectorize
endif

ifeq ($(strip $(ENABLE_SABERMOD_ARM_MODE)),true)
  # SABERMOD_ARM_MODE
  # The LOCAL_COMPILERS_WHITELIST will allow modules that absolutely have to be complied with thumb instructions,
  # or the clang compiler, to skip replacing the default overrides.

  LOCAL_ARM_COMPILERS_WHITELIST_BASE := \
    libmincrypt \
    libc++abi \
    libjni_latinime_common_static \
    libcompiler_rt \
    libnativebridge \
    libc++ \
    libRSSupport \
    netd \
    libscrypt_static \
    libRSCpuRef \
    libRSDriver \
    mdnsd \
    $(NO_OPTIMIZATIONS)

  LOCAL_ARM64_COMPILERS_WHITELIST_BASE := \
    libc++abi \
    libcompiler_rt \
    libnativebridge \
    libjni_latinime_common_static \
    libRSSupport \
    libc++ \
    libRSCpuRef \
    netd \
    libRSDriver \
    libjpeg \
    mdnsd \
    $(NO_OPTIMIZATIONS)

  # Check if there's already something set somewhere.
  ifndef LOCAL_ARM_COMPILERS_WHITELIST
    LOCAL_ARM_COMPILERS_WHITELIST := \
      $(LOCAL_ARM_COMPILERS_WHITELIST_BASE)
  else
    LOCAL_ARM_COMPILERS_WHITELIST += \
      $(LOCAL_ARM_COMPILERS_WHITELIST_BASE)
  endif
  ifndef LOCAL_ARM64_COMPILERS_WHITELIST
    LOCAL_ARM64_COMPILERS_WHITELIST := \
      $(LOCAL_ARM64_COMPILERS_WHITELIST_BASE)
  else
    LOCAL_ARM64_COMPILERS_WHITELIST += \
      $(LOCAL_ARM64_COMPILERS_WHITELIST_BASE)
  endif
endif
# Disable some modules that should be debuggable
LOCAL_DEBUGGING_WHITELIST_BASE := \
$(NO_OPTIMIZATIONS)

# Check if there's already something set somewhere.
ifndef LOCAL_DEBUGGING_WHITELIST
  LOCAL_DEBUGGING_WHITELIST := \
    $(LOCAL_DEBUGGING_WHITELIST_BASE)
else
  LOCAL_DEBUGGING_WHITELIST += \
    $(LOCAL_DEBUGGING_WHITELIST_BASE)
endif

# Enable some basic host gcc optimizations
# None that are cpu specific but arch is ok.
EXTRA_SABERMOD_HOST_GCC := \
  -ftree-vectorize

# Extra SaberMod CLANG C flags
EXTRA_SABERMOD_CLANG := \
  -ftree-vectorize

# Check if there's already something set somewhere.
ifndef LOCAL_DISABLE_SABERMOD_GCC_VECTORIZE
  LOCAL_DISABLE_SABERMOD_GCC_VECTORIZE := $(NO_OPTIMIZATIONS)
else
  LOCAL_DISABLE_SABERMOD_GCC_VECTORIZE += $(NO_OPTIMIZATIONS)
endif

# Check if there's already something set somewhere.
ifndef LOCAL_DISABLE_SABERMOD_CLANG_VECTORIZE
  LOCAL_DISABLE_SABERMOD_CLANG_VECTORIZE := $(NO_OPTIMIZATIONS)
else
  LOCAL_DISABLE_SABERMOD_CLANG_VECTORIZE += $(NO_OPTIMIZATIONS)
endif

# Some flags are only available for certain gcc versions
export DISABLE_SANITIZE_LEAK := $(filter 4.8%,$(SM_AND_NAME))

# Enable SaberMod extra for all arm builds.
ifneq ($(filter arm arm64,$(LOCAL_ARCH)),)
  ifneq ($(ENABLE_SABERMOD_EXTRA),false)
    ENABLE_SABERMOD_EXTRA := true
    OPT3 := [extra]
  endif
endif

# Enable Leak Sanitizer and OpenMP for all arm builds.
ifneq ($(filter arm arm64,$(LOCAL_ARCH)),)
  ifneq ($(ENABLE_LSAN_OPENMP),false)
    ENABLE_LSAN_OPENMP := true
    OPT6 := [lsan]
    OPT7 := [OpenMP]
  endif
endif

# Right all optimization level options to build.prop
GCC_OPTIMIZATION_LEVELS := $(OPT1)$(OPT2)$(OPT4)$(OPT3)$(OPT6)$(OPT7)$(OPT8)$(OPT5)
ifneq ($(GCC_OPTIMIZATION_LEVELS),)
  PRODUCT_PROPERTY_OVERRIDES += \
    ro.sm.flags="$(GCC_OPTIMIZATION_LEVELS)"
endif
