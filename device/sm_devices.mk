# Copyright (C) 2015 The SaberMod Project
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

ifneq ($(filter awifi,$(TARGET_DEVICE)),)
  include $(SM_VENDOR)/device/sm_awifi.mk
  LOCAL_ARCH := arm
endif

ifneq ($(filter z3,$(TARGET_DEVICE)),)
  include $(SM_VENDOR)/device/sm_z3.mk
  LOCAL_ARCH := arm
endif

ifneq ($(filter huashan,$(TARGET_DEVICE)),)
  include $(SM_VENDOR)/device/sm_huashan.mk
  LOCAL_ARCH := arm
endif

# Kernel binary prefix.  The other part of this will go in the kernel source's AndroidKernel.mk.
# And also in defconfigs (arch/arm/configs/name_defconfig)(or arm64) CONFIG_CROSS_COMPILE="arm-eabi-" (or "aarch64-")
ifeq ($(strip $(LOCAL_ARCH)),arm)
export CROSS_COMPILE_NAME := arm-$(HOST_OS)-gnueabi-
endif

ifeq ($(strip $(LOCAL_ARCH)),arm64)
export CROSS_COMPILE_NAME := aarch64-$(HOST_OS)-gnu-
endif

