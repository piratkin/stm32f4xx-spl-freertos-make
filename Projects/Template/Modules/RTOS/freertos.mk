################################################################################
#                   SOURCE FILES DIRECTORIES                                   #
################################################################################

RTOS_ROOT = ${TOOLS_ROOT}/Libraries/RTOS/FreeRTOSv9.0.0/FreeRTOS

RTOS_SRC_DIR      = $(RTOS_ROOT)/Source
RTOS_SRC_DIR     += $(RTOS_ROOT)/Source/portable/Common
RTOS_SRC_DIR     += $(RTOS_ROOT)/Source/portable/MemMang
RTOS_SRC_DIR     += $(RTOS_ROOT)/Source/portable/GCC/ARM_CM4F

# Tell make to look in that folder if it cannot find a source
# in the current directory
vpath %.c $(RTOS_SRC_DIR)

################################################################################
#                   HEADER FILES DIRECTORIES                                   #
################################################################################

# The header files we use are located here
INC_DIRS += $(RTOS_ROOT)/Demo/CORTEX_M4F_CEC1302_Keil_GCC
INC_DIRS += $(RTOS_ROOT)/Source/portable/GCC/ARM_CM4_MPU
INC_DIRS += $(RTOS_ROOT)/Source/include

################################################################################
#                   SOURCE FILES TO COMPILE                                    #
################################################################################

# These source files implement the functions we use.
# make finds them by searching the vpath defined above.

SRCS  += croutine.c
SRCS  += event_groups.c
SRCS  += list.c
SRCS  += queue.c
SRCS  += tasks.c
SRCS  += timers.c

SRCS  += port.c
SRCS  += heap_4.c
SRCS  += mpu_wrappers.c

SRCS  += hooks.c

# in case we have to many sources and don't want 
# to compile all sources every time
OBJS += $(SRCS:.c=.o)