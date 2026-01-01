# !! Everything in this file is just a placeholder / "example" !!
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR ARM)

set(TOOLCHAIN_PREFIX "arm-none-eabi")

set(CMAKE_C_COMPILER   "${TOOLCHAIN_PREFIX}-gcc")
set(CMAKE_AR           "${TOOLCHAIN_PREFIX}-ar")
set(CMAKE_RANLIB       "${TOOLCHAIN_PREFIX}-ranlib")
set(CMAKE_OBJCOPY      "${TOOLCHAIN_PREFIX}-objcopy")
set(CMAKE_SIZE_UTIL    "${TOOLCHAIN_PREFIX}-size")

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# CPU, FPU, float ABI:
set(TPL_BAREMETAL_CPU "cortex-m3" CACHE STRING "Cortex-M CPU (e.g., cortex-m0/m3/m4/m7)")
set(TPL_BAREMETAL_FPU "" CACHE STRING "FPU (e.g., fpv4-sp-d16) or empty")
set(TPL_BAREMETAL_FLOAT_ABI "" CACHE STRING "float ABI (soft/softfp/hard) or empty")

set(TPL_LINKER_SCRIPT "" CACHE FILEPATH "Linker script (.ld)")

set(_cpu_flags "-mcpu=${TPL_BAREMETAL_CPU} -mthumb")

set(_fpu_flags "")
if(TPL_BAREMETAL_FPU AND TPL_BAREMETAL_FLOAT_ABI)
  set(_fpu_flags "-mfpu=${TPL_BAREMETAL_FPU} -mfloat-abi=${TPL_BAREMETAL_FLOAT_ABI}")
endif()

set(_c_flags_common
  "${_cpu_flags} ${_fpu_flags}"
  "-ffunction-sections -fdata-sections"
  "-fno-builtin"
  "-fno-exceptions"
  "-fno-unwind-tables -fno-asynchronous-unwind-tables"
)

set(_freestanding_flags "-ffreestanding")

set(CMAKE_C_FLAGS_INIT "${_c_flags_common} ${_freestanding_flags}")

set(_ld_flags_common
  "${_cpu_flags} ${_fpu_flags}"
  "-Wl,--gc-sections"
  "-Wl,-Map=${CMAKE_BINARY_DIR}/tpl.map"
)

if(TPL_LINKER_SCRIPT)
  set(_ld_flags_common "${_ld_flags_common} -T${TPL_LINKER_SCRIPT}")
endif()

set(CMAKE_EXE_LINKER_FLAGS_INIT "${_ld_flags_common}")

