################################################################################
#                   SOURCE FILES DIRECTORIES                                   #
################################################################################

# This is the directory containing the firmware package,
# the unzipped folder downloaded from here:
# http://www.st.com/web/en/catalog/tools/PF257904
STM_ROOT = ${TOOLS_ROOT}/Libraries/Discovery/STM32F4-Discovery_FW_V1.1.0

# This is where the source files are located,
# which are not in the current directory
# (the sources of the standard peripheral library, which we use)
# see also "info:/make/Selective Search" in Konqueror
STM_SRC_DIR      = $(STM_ROOT)/Libraries/STM32F4xx_StdPeriph_Driver/src
STM_SRC_DIR     += $(STM_ROOT)/Utilities/STM32F4-Discovery

STM_STARTUP_DIR += $(STM_ROOT)/Libraries/CMSIS/ST/STM32F4xx/Source/Templates/gcc_ride7

# Tell make to look in that folder if it cannot find a source
# in the current directory
vpath %.c $(STM_SRC_DIR)
vpath %.s $(STM_STARTUP_DIR)

################################################################################
#                   HEADER FILES DIRECTORIES                                   #
################################################################################

# The header files we use are located here
INC_DIRS += $(STM_ROOT)/Utilities/STM32F4-Discovery
INC_DIRS += $(STM_ROOT)/Libraries/CMSIS/Include
INC_DIRS += $(STM_ROOT)/Libraries/CMSIS/ST/STM32F4xx/Include
INC_DIRS += $(STM_ROOT)/Libraries/STM32F4xx_StdPeriph_Driver/inc
INC_DIRS += .

################################################################################
#                   SOURCE FILES TO COMPILE                                    #
################################################################################

# Contains initialisation code and must be compiled into
# our project. This file is in the current directory and
# was writen by ST.
SRCS  += system_stm32f4xx.c

# These source files implement the functions we use.
# make finds them by searching the vpath defined above.

SRCS  += stm32f4xx_adc.c
SRCS  += stm32f4xx_can.c
SRCS  += stm32f4xx_crc.c
SRCS  += stm32f4xx_cryp.c
SRCS  += stm32f4xx_dac.c
SRCS  += stm32f4xx_dbgmcu.c
SRCS  += stm32f4xx_dcmi.c
SRCS  += stm32f4xx_dma.c
SRCS  += stm32f4xx_exti.c
SRCS  += stm32f4xx_flash.c
SRCS  += stm32f4xx_fsmc.c
SRCS  += stm32f4xx_hash.c
SRCS  += stm32f4xx_gpio.c
SRCS  += stm32f4xx_i2c.c
SRCS  += stm32f4xx_iwdg.c
SRCS  += stm32f4xx_pwr.c
SRCS  += stm32f4xx_rcc.c
SRCS  += stm32f4xx_rng.c
SRCS  += stm32f4xx_rtc.c
SRCS  += stm32f4xx_sdio.c
SRCS  += stm32f4xx_spi.c
SRCS  += stm32f4xx_syscfg.c
SRCS  += stm32f4xx_tim.c
SRCS  += stm32f4xx_usart.c
SRCS  += stm32f4xx_wwdg.c
SRCS  += misc.c

# Startup file written by ST
# The assembly code in this file is the first one to be
# executed. Normally you do not change this file.
ASRC  = startup_stm32f4xx.s

# in case we have to many sources and don't want 
# to compile all sources every time
OBJS += $(SRCS:.c=.o)
OBJS += $(ASRC:.s=.o)