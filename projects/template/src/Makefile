# Binaries will be generated with this name (.elf, .bin, .hex, etc)
PROJ_NAME=firmware

TOOLS_ROOT=../../..
################################################################################
#                   SETUP TOOLS                                                #
################################################################################

ifeq ($(OS),Windows_NT)
	# This is the path to the toolchain
	TOOLS_DIR = ${TOOLS_ROOT}/windows/arm-none-eabi
	# Put your stlink folder here so make burn will work.
	STLINK = ${TOOLS_ROOT}/windows/stlinlk
	OPENOCD = ${TOOLS_ROOT}/windows/openocd
else
	# This is the path to the toolchain
	TOOLS_DIR = ${TOOLS_ROOT}/linux/arm-none-eabi
	# Put your stlink folder here so make burn will work.
	STLINK = ${TOOLS_ROOT}/linux/stlink
	OPENOCD = ${TOOLS_ROOT}/linux/openocd

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

CFLAGS  = -ggdb
# please do not optimize anything because we are debugging
CFLAGS += -O0 
CFLAGS += -Wall -Wextra -Warray-bounds
CFLAGS += $(AFLAGS)

##### Linker options

# tell ld which linker file to use
# (this file is in the current directory)
LFLAGS  = -Tstm32_flash.ld

################################################################################
#                   SOURCE FILES DIRECTORIES                                   #
################################################################################

# This is the directory containing the firmware package,
# the unzipped folder downloaded from here:
# http://www.st.com/web/en/catalog/tools/PF257904
STM_ROOT = ${TOOLS_ROOT}/STM32F4-Discovery_FW_V1.1.0

# This is where the source files are located,
# which are not in the current directory
# (the sources of the standard peripheral library, which we use)
# see also "info:/make/Selective Search" in Konqueror
STM_SRC_DIR      = $(STM_ROOT)/Libraries/STM32F4xx_StdPeriph_Driver/src
STM_SRC_DIR     += $(STM_ROOT)/Utilities/STM32F4-Discovery
STM_STARTUP_DIR += $(STM_ROOT)/Libraries/CMSIS/ST/STM32F4xx/Source/Templates/TrueSTUDIO

# Tell make to look in that folder if it cannot find a source
# in the current directory
vpath %.c $(STM_SRC_DIR)
vpath %.s $(STM_STARTUP_DIR)

################################################################################
#                   HEADER FILES DIRECTORIES                                   #
################################################################################

# The header files we use are located here
INC_DIRS  = $(STM_ROOT)/Utilities/STM32F4-Discovery
INC_DIRS += $(STM_ROOT)/Libraries/CMSIS/Include
INC_DIRS += $(STM_ROOT)/Libraries/CMSIS/ST/STM32F4xx/Include
INC_DIRS += $(STM_ROOT)/Libraries/STM32F4xx_StdPeriph_Driver/inc
INC_DIRS += .


################################################################################
#                   SOURCE FILES TO COMPILE                                    #
################################################################################


# My source file
SRCS   += main.c

# Contains initialisation code and must be compiled into
# our project. This file is in the current directory and
# was writen by ST.
SRCS  += system_stm32f4xx.c

# These source files implement the functions we use.
# make finds them by searching the vpath defined above.
SRCS  += stm32f4xx_rcc.c 
SRCS  += stm32f4xx_gpio.c
SRCS  += stm32f4xx_tim.c
SRCS  += misc.c

# Startup file written by ST
# The assembly code in this file is the first one to be
# executed. Normally you do not change this file.
ASRC  = startup_stm32f4xx.s

# in case we have to many sources and don't want 
# to compile all sources every time
OBJS  = $(SRCS:.c=.o)
OBJS += $(ASRC:.s=.o)

######################################################################
#                         SETUP TARGETS                              #
######################################################################

.PHONY: all debug

all: $(PROJ_NAME).elf

%.o : %.c
	@echo "[Compiling  ]  $^"
	@$(CC) -c -o $@ $(INCLUDE) $(DEFS) $(CFLAGS) $^

%.o : %.s
	@echo "[Assembling ]" $^
	@$(AS) $(AFLAGS) $< -o $@

$(PROJ_NAME).elf: $(OBJS)
	@echo "[Linking    ]  $@"
	@$(CC) $(CFLAGS) $(LFLAGS) $^ -o $@ 
	@$(OBJCOPY) -O ihex $(PROJ_NAME).elf $(PROJ_NAME).hex
	@$(OBJCOPY) -O binary $(PROJ_NAME).elf $(PROJ_NAME).bin

clean:
	rm -f *.o $(PROJ_NAME).elf $(PROJ_NAME).hex $(PROJ_NAME).bin

# Flash the STM32F4
stflash: all
	$LD_LIBRARY_PATH=$(STLINK)/lib (STLINK)/bin/st-flash write $(PROJ_NAME).bin 0x8000000

# Flash the STM32F4
ocdflash: all 
	$(OPENOCD)/bin/openocd -f interface/stlink-v2.cfg -f board/stm32f4discovery.cfg -c "init" -c "reset init" -c "flash write_image erase $(PROJ_NAME).hex" -c "reset" -c "shutdown"
debug:
# before you start gdb, you must start st-util
	$(GDB) $(PROJ_NAME).elf --tui 

# connect to device
stcon:
	LD_LIBRARY_PATH=$(STLINK)/lib $(STLINK)/bin/st-util

# connect to device
ocdcon:
	$(OPENOCD)/bin/openocd -f interface/stlink-v2.cfg -f board/stm32f4discovery.cfg
