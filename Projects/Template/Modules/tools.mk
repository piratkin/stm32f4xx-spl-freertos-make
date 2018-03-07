################################################################################
#                   SETUP TOOLS                                                #
################################################################################

# System setups
ifeq ($(OS),Windows_NT)
    include $(TOOLS_ROOT)/Projects/Template/Modules/System/windows.mk
else
    include $(TOOLS_ROOT)/Projects/Template/Modules/System/linux.mk
endif

# The tool we use
CC      = $(TOOLS_DIR)/bin/arm-none-eabi-gcc
OBJCOPY = $(TOOLS_DIR)/bin/arm-none-eabi-objcopy
GDB     = $(TOOLS_DIR)/bin/arm-none-eabi-gdb
AS      = $(TOOLS_DIR)/bin/arm-none-eabi-as

##### Preprocessor options

# directories to be searched for header files
INCLUDE = $(addprefix -I,$(INC_DIRS))

# Defines needed when working with the STM library
DEFS    = -DUSE_STDPERIPH_DRIVER
# if you use the following option, you must implement the function 
#    assert_failed(uint8_t* file, uint32_t line)
# because it is conditionally used in the library
# DEFS   += -DUSE_FULL_ASSERT

##### Assembler options

AFLAGS  = -mcpu=cortex-m4 
AFLAGS += -mthumb
AFLAGS += -mthumb-interwork
AFLAGS += -mlittle-endian
AFLAGS += -mfloat-abi=hard
AFLAGS += -mfpu=fpv4-sp-d16

##### Compiler options

ifdef RELEASE

    $(info [* RELEASE *])
    # Produces no debug information at all
    CFLAGS  = -g0
    # Optimize yet more.
    CFLAGS += -O3

else

    # Produce debugging information for use by GDB
    CFLAGS  = -ggdb
    # Please do not optimize anything because we are debugging
    CFLAGS += -O0

endif

CFLAGS += -Wall -Wextra -Warray-bounds
CFLAGS += $(AFLAGS)

##### Linker options

# tell ld which linker file to use
# (this file is in the current directory)
LFLAGS  = -Tstm32_flash.ld
