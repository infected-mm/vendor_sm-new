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

# Sabermod configs
TARGET_SM_KERNEL := 4.9
HUASHAN_THREADS := 2
PRODUCT_THREADS := $(HUASHAN_THREADS)
LOCAL_STRICT_ALIASING := true
LOCAL_O3 := true

LOCAL_DISABLE_STRICT_ALIASING := \
	libcrypto_static \
	gatt_testtool \
	libssh \
	ssh \
	libsurfaceflinger \
	libOmxVenc \
	lsof

LOCAL_DISABLE_GRAPHITE := libncurses

  GRAPHITE_KERNEL_FLAGS := \
    -floop-parallelize-all \
    -ftree-parallelize-loops=$(PRODUCT_THREADS) \
    -fopenmp

# General flags for gcc 4.9 to allow compilation to complete.
NO_OPTIMIZATIONS := hwcomposer.msm8960

# Extra SaberMod GCC C flags for arch target and Kernel
export EXTRA_SABERMOD_GCC_VECTORIZE := \
         -mvectorize-with-neon-quad
