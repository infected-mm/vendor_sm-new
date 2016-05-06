# Compile the kernel inline

# Note for this to work you will need to remove prebuilt kernel building in device tree,
# and any other inline kernel building implementations.

# Original Author Jameson Williams jameson.h.williams@intel.com

ifneq ($(filter %hammerhead,$(TARGET_PRODUCT)),)
  KERNEL_DIR := kernel/lge/hammerhead
  KERNEL_BINARY_IMAGE := zImage-dtb
  ifneq ($(filter pa% slim%,$(TARGET_PRODUCT)),)
    KERNEL_DEFCONFIG := sabermod_hammerhead_defconfig
  endif
endif

ifneq ($(filter %mako,$(TARGET_PRODUCT)),)
  KERNEL_DIR := kernel/lge/mako
  KERNEL_BINARY_IMAGE := zImage
  ifneq ($(filter pa% slim%,$(TARGET_PRODUCT)),)
    KERNEL_DEFCONFIG := sabermod_mako_defconfig
  endif
endif

ifneq ($(filter %shamu,$(TARGET_PRODUCT)),)
  KERNEL_DIR := kernel/moto/shamu
  KERNEL_BINARY_IMAGE := zImage-dtb
  ifneq ($(filter pa%,$(TARGET_PRODUCT)),)
    KERNEL_DEFCONFIG := sabermod_shamu_defconfig
  endif
endif

ifneq ($(filter %sumire,$(TARGET_PRODUCT)),)
  KERNEL_DIR := kernel/sony/msm
  KERNEL_BINARY_IMAGE := zImage-dtb
  ifneq ($(filter omni% aosp% carbon%,$(TARGET_PRODUCT)),)
    KERNEL_DEFCONFIG := aosp_kitakami_sumire_defconfig
  endif
endif

ifdef KERNEL_DIR
  include $(KERNEL_DIR)/AndroidKernel.mk

  # cp will do.
  .PHONY: $(PRODUCT_OUT)/kernel
  $(PRODUCT_OUT)/kernel: $(TARGET_PREBUILT_KERNEL)
	cp $(TARGET_PREBUILT_KERNEL) $(PRODUCT_OUT)/kernel
endif

