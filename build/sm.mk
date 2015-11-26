##########################################################################
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
##########################################################################

# arm mode
include $(SM_VENDOR)/build/arm.mk

# Extra sabermod optimizations
include $(SM_VENDOR)/build/extra.mk

# Strict Aliasing optimizations
include $(SM_VENDOR)/build/strict.mk

# CPU Tuning flags
include $(SM_VENDOR)/build/tune.mk

# O3 optimzations
ifeq ($(strip $(LOCAL_O3)),true)
  ifneq ($(strip $(LOCAL_ARM_MODE))-$(strip $(LOCAL_DISABLE_O3_THUMB)),thumb-true)
    ifneq (1,$(words $(filter $(LOCAL_DISABLE_O3),$(LOCAL_MODULE))))
      ifdef LOCAL_CFLAGS
        LOCAL_CFLAGS += $(O3_FLAGS)
      else
        LOCAL_CFLAGS := $(O3_FLAGS)
      endif
    else
      ifneq (1,$(words $(filter $(NO_OPTIMIZATIONS),$(LOCAL_MODULE))))
        ifdef LOCAL_CFLAGS
          LOCAL_CFLAGS += -O2
        else
          LOCAL_CFLAGS := -O2
        endif
      endif
    endif
  endif
endif

# IPA Analyser Optimizations
ifeq (,$(filter true,$(LOCAL_CLANG)))
  ifneq (1,$(words $(filter $(LOCAL_DISABLE_IPA),$(LOCAL_MODULE))))
    ifdef LOCAL_CFLAGS
#      LOCAL_CFLAGS += -fipa-sra -fipa-pta -fipa-cp -fipa-cp-clone
    else
#      LOCAL_CFLAGS := -fipa-sra -fipa-pta -fipa-cp -fipa-cp-clone
    endif
    ifdef LOCAL_LDFLAGS
#      LOCAL_LDFLAGS += -fipa-sra -fipa-pta -fipa-cp -fipa-cp-clone
    else
#      LOCAL_LDFLAGS := -fipa-sra -fipa-pta -fipa-cp -fipa-cp-clone
    endif
  endif
endif

# Do not use graphite on host modules or the clang compiler.
ifeq (,$(filter true,$(LOCAL_IS_HOST_MODULE) $(LOCAL_CLANG)))

  # If it gets this far enable graphite by default from here on out.
  ifneq (1,$(words $(filter $(LOCAL_DISABLE_GRAPHITE),$(LOCAL_MODULE))))
    ifdef LOCAL_CFLAGS
      LOCAL_CFLAGS += $(GRAPHITE_FLAGS)
    else
      LOCAL_CFLAGS := $(GRAPHITE_FLAGS)
    endif
    ifdef LOCAL_LDFLAGS
      LOCAL_LDFLAGS += $(GRAPHITE_FLAGS)
    else
      LOCAL_LDFLAGS := $(GRAPHITE_FLAGS)
    endif
    GRAPHITE_IS_ENABLED := true
  else
    GRAPHITE_IS_ENABLED := false
  endif
else
  GRAPHITE_IS_ENABLED := false
endif

# General flags for gcc 4.9+ to allow compilation to complete.
# Many of these are device specific and should be set in device make files.
# See vendor/sm.  Add more sections below, and also to vendor/sm/device/sm_device.mk if need be.

# modules that need -Wno-error=maybe-uninitialized
ifdef MAYBE_UNINITIALIZED
  ifeq (1,$(words $(filter $(MAYBE_UNINITIALIZED),$(LOCAL_MODULE))))
    ifdef LOCAL_CFLAGS
      LOCAL_CFLAGS += -Wno-error=maybe-uninitialized
    else
      LOCAL_CFLAGS := -Wno-error=maybe-uninitialized
    endif
  endif
endif

ifneq ($(filter 5.1% 5.2% 6.0%,$(SM_AND_NAME)),)
  ifdef WARN_NO_ERROR
    ifeq (1,$(words $(filter $(WARN_NO_ERROR),$(LOCAL_MODULE))))
      ifdef LOCAL_CFLAGS
        LOCAL_CFLAGS += -Wno-error
      else
        LOCAL_CFLAGS := -Wno-error
      endif
    endif
  endif
endif

include $(SM_VENDOR)/build/hybrid.mk

#end SaberMod
