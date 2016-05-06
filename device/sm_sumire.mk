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
TARGET_SM_AND := 4.9
SUMIRE_THREADS := 8
PRODUCT_THREADS := $(SUMIRE_THREADS)
LOCAL_STRICT_ALIASING := false
LOCAL_O3 := true

GRAPHITE_KERNEL_FLAGS := \
  -floop-parallelize-all \
  -ftree-parallelize-loops=$(PRODUCT_THREADS)
