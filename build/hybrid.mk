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

# Hybrid toolchain mode default to on.
ifeq ($(strip $(TARGET_ARCH)),arm)
  ifndef LOCAL_IS_HOST_MODULE
    ifneq ($(my_clang),true)
      ifneq ($(filter 5.% 6.%,$(SM_AND_NAME)),)
        ifeq (1,$(words $(filter $(GCC_4_9_MODULES), $(LOCAL_MODULE))))
          LOCAL_CC := prebuilts/gcc/$(HOST_PREBUILT_TAG)/arm/arm-linux-androideabi-$(TARGET_SECOND_SM_AND)/bin/arm-linux-androideabi-gcc$(HOST_EXECUTABLE_SUFFIX)
          LOCAL_CXX := prebuilts/gcc/$(HOST_PREBUILT_TAG)/arm/arm-linux-androideabi-$(TARGET_SECOND_SM_AND)/bin/arm-linux-androideabi-g++

          # Add extra libs and includes for the compilers to use
          export LD_LIBRARY_PATH := $(TARGET_ARCH_SECOND_LIB_PATH):$(LD_LIBRARY_PATH)
          export LIBRARY_PATH := $(TARGET_ARCH_SECOND_LIB_PATH):$(LIBRARY_PATH)
          export C_INCLUDE_PATH := $(TARGET_ARCH_SECOND_INC_PATH):$(C_INCLUDE_PATH)
          export CPLUS_INCLUDE_PATH := $(TARGET_ARCH_SECOND_INC_PATH):$(C_INCLUDE_PATH)
        else
          ifeq (true,$(strip $(GRAPHITE_IS_ENABLED)))
            LOCAL_CFLAGS += -floop-unroll-and-jam
            LOCAL_LDFLAGS += -floop-unroll-and-jam
          endif

          # Add extra libs and includes for the compilers to use
          export LD_LIBRARY_PATH := $(TARGET_ARCH_LIB_PATH):$(LD_LIBRARY_PATH)
          export LIBRARY_PATH := $(TARGET_ARCH_LIB_PATH):$(LIBRARY_PATH)
          export C_INCLUDE_PATH := $(TARGET_ARCH_INC_PATH):$(C_INCLUDE_PATH)
          export CPLUS_INCLUDE_PATH := $(TARGET_ARCH_INC_PATH):$(C_INCLUDE_PATH)
        endif
      else

        # Add extra libs and includes for the compilers to use
        export LD_LIBRARY_PATH := $(TARGET_ARCH_LIB_PATH):$(LD_LIBRARY_PATH)
        export LIBRARY_PATH := $(TARGET_ARCH_LIB_PATH):$(LIBRARY_PATH)
        export C_INCLUDE_PATH := $(TARGET_ARCH_INC_PATH):$(C_INCLUDE_PATH)
        export CPLUS_INCLUDE_PATH := $(TARGET_ARCH_INC_PATH):$(C_INCLUDE_PATH)
      endif
    endif
  endif
endif
