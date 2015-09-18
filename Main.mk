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

# HOST_OS
UNAME := $(shell uname -s)
ifneq (,$(findstring Linux,$(UNAME)))
  HOST_OS := linux
endif
ifneq (,$(findstring Darwin,$(UNAME)))
  HOST_OS := darwin
endif
ifneq (,$(findstring Macintosh,$(UNAME)))
  HOST_OS := darwin
endif
ifneq (,$(findstring CYGWIN,$(UNAME)))
  HOST_OS := windows
endif

include $(SM_VENDOR)/configs/clear_vars.mk
include $(SM_VENDOR)/product/sm_products.mk
include $(SM_VENDOR)/device/sm_devices.mk
include $(SM_VENDOR)/configs/sm.mk

# SuperSU for aosp based ROMs.
ifeq ($(strip $(TARGET_BASE_ROM)),aosp)
  include $(SM_VENDOR)/prebuilts/SuperSU/supersu.mk
endif
