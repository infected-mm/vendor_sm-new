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

$(info =====================================================================)
ifdef TARGET_DEVICE
$(info   TARGET_DEVICE=$(TARGET_DEVICE))
endif
ifdef TARGET_BASE_ROM
$(info   TARGET_BASE_ROM=$(TARGET_BASE_ROM))
endif
ifdef SM_AND_NAME
$(info   TARGET_SABERMOD_ANDROID_GCC_VERSION=$(SM_AND_NAME))
endif
ifdef SM_KERNEL_NAME
$(info   TARGET_SABERMOD_KERNEL_GCC_VERSION=$(SM_KERNEL_NAME))
endif
ifdef TARGET_NDK_VERSION
$(info   TARGET_NDK_VERSION=$(TARGET_NDK_VERSION))
else
$(info   TARGET_NDK_VERSION=$(SM_AND_VERSION))
endif
ifdef GCC_OPTIMIZATION_LEVELS
$(info   OPTIMIZATIONS=$(GCC_OPTIMIZATION_LEVELS))
endif
$(info =====================================================================)
