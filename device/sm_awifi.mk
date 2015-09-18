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

# Device specific Sabermod configs
TARGET_SM_AND := 4.9
TARGET_SM_KERNEL := 4.9
LOCAL_STRICT_ALIASING := true
export LOCAL_O3 := true

# Configs for ROM on GCC 4.8
ifeq ($(strip $(TARGET_SM_AND)),4.8)

endif

# Configs for ROM on GCC 4.9
ifeq ($(strip $(TARGET_SM_AND)),4.9)
  LOCAL_DISABLE_O3 := \
    libminshacrypt \
    libFraunhoferAAC

  NO_OPTIMIZATIONS := \
    libFraunhoferAAC
endif

ifneq ($(filter 4.9,$(TARGET_SM_KERNEL)),)
  GRAPHITE_KERNEL_FLAGS := \
    -fopenmp
endif

# Extra SaberMod GCC C flags for arch target and Kernel
export EXTRA_SABERMOD_GCC_VECTORIZE := \
         -mvectorize-with-neon-quad


ifeq ($(strip $(LOCAL_STRICT_ALIASING)),true)

  # Disable lists for GCC4.8/4.9
  ifeq ($(strip $(TARGET_SM_AND)),4.8)
    DISABLE_STRICT := \
      gatt_testtool

    LOCAL_DISABLE_GRAPHITE := \
      libncurses
  endif

  ifeq ($(strip $(TARGET_SM_AND)),4.9)
    DISABLE_STRICT := \
      gatt_testtool

    LOCAL_DISABLE_GRAPHITE := \
      libncurses
  endif

  # Check if something is already set in configs/sm.mk
  ifndef LOCAL_DISABLE_STRICT_ALIASING
    LOCAL_DISABLE_STRICT_ALIASING := \
      $(DISABLE_STRICT)
  else
    LOCAL_DISABLE_STRICT_ALIASING += \
      $(DISABLE_STRICT)
  endif
endif

