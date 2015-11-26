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

# Extra SaberMod C flags for gcc and clang
# Seperated by arch, clang and host

ifeq ($(strip $(ENABLE_SABERMOD_EXTRA)),true)
# Target build flags
ifeq (,$(filter true,$(LOCAL_IS_HOST_MODULE) $(LOCAL_CLANG)))
  ifdef EXTRA_SABERMOD_GCC_VECTORIZE
    ifneq (1,$(words $(filter $(LOCAL_DISABLE_SABERMOD_GCC_VECTORIZE),$(LOCAL_MODULE))))
      ifdef LOCAL_CFLAGS
        LOCAL_CFLAGS += $(EXTRA_SABERMOD_GCC_VECTORIZE)
      else
        LOCAL_CFLAGS := $(EXTRA_SABERMOD_GCC_VECTORIZE)
      endif
    endif
  endif
  ifdef LOCAL_CFLAGS
    LOCAL_CFLAGS += $(EXTRA_SABERMOD_GCC)
  else
    LOCAL_CFLAGS := $(EXTRA_SABERMOD_GCC)
  endif
endif

# Clang vectorization flags.
ifneq ($(strip $(LOCAL_IS_HOST_MODULE)),true)
  ifeq ($(strip $(LOCAL_CLANG)),true)
    ifneq (1,$(words $(filter $(LOCAL_DISABLE_SABERMOD_CLANG_VECTORIZE),$(LOCAL_MODULE))))
      ifdef LOCAL_CFLAGS
        LOCAL_CFLAGS += $(LOCAL_SABERMOD_CLANG_VECTORIZE)
      else
        LOCAL_CFLAGS := $(LOCAL_SABERMOD_CLANG_VECTORIZE)
      endif
    endif
  endif
endif

# Host gcc flags
ifeq ($(strip $(LOCAL_IS_HOST_MODULE)),true)
  ifneq ($(strip $(LOCAL_CLANG)),true)
    ifdef LOCAL_CFLAGS
      LOCAL_CFLAGS += $(EXTRA_SABERMOD_HOST_GCC)
    else
      LOCAL_CFLAGS := $(EXTRA_SABERMOD_HOST_GCC)
    endif
    LOCAL_CFLAGS += $(EXTRA_SABERMOD_HOST_GCC)
  endif
endif
endif

ifeq ($(strip $(ENABLE_LSAN_OPENMP)),true)
# Use the memory leak sanitizer and openmp for all arm targets.
ifneq ($(filter arm arm64,$(TARGET_ARCH)),)
  ifeq (,$(filter true,$(LOCAL_IS_HOST_MODULE) $(LOCAL_CLANG)))
    ifneq (1,$(words $(DISABLE_SANITIZE_LEAK)))
      ifneq (1,$(words $(filter $(GCC_4_8_MODULES),$(LOCAL_MODULE))))
        ifdef LOCAL_CONLYFLAGS
          LOCAL_CONLYFLAGS += -fsanitize=leak
        else
          LOCAL_CONLYFLAGS := -fsanitize=leak
        endif
      endif
      ifneq (1,$(words $(filter libwebviewchromium libc_netbsd,$(LOCAL_MODULE))))
        ifdef LOCAL_CFLAGS
          LOCAL_CFLAGS += -lgomp -ldl -lgcc -fopenmp
        else
          LOCAL_CFLAGS := -lgomp -ldl -lgcc -fopenmp
        endif
        ifdef LOCAL_LDLIBS
          LOCAL_LDLIBS += -lgomp -lgcc
        else
          LOCAL_LDLIBS := -lgomp -lgcc
        endif
      endif
    endif
  endif
endif
endif

# Decrease debugging if FORCE_DISABLE_DEBUGGING is true.
ifeq ($(filter true 1,$(FORCE_DISABLE_DEBUGGING)),)
  ifneq ($(strip $(LOCAL_CLANG)),true)
    ifneq (1,$(words $(LOCAL_DEBUGGING_WHITELIST)))
      ifdef LOCAL_CFLAGS
        LOCAL_CFLAGS += -g0
      else
        LOCAL_CFLAGS := -g0
      endif
      ifdef LOCAL_CPPFLAGS
        LOCAL_CPPFLAGS += -g0
      else
        LOCAL_CPPFLAGS := -g0
      endif
    endif
  endif
endif
