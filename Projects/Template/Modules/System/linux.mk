# This is the path to the toolchain
TOOLS_DIR = ${TOOLS_ROOT}/Linux/arm-none-eabi

# Put your stlink/openocd folder
STLINK = ${TOOLS_ROOT}/Linux/stlink
OPENOCD = ${TOOLS_ROOT}/Linux/openocd

# Variable
LD_LIBRARY_PATH := $(STLINK)/lib 
export LD_LIBRARY_PATH 