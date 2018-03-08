# This is the path to the toolchain
TOOLS_DIR = ${TOOLS_ROOT}/Windows/arm-none-eabi

# Put your stlink/openocd folder
STLINK = ${TOOLS_ROOT}/Windows/stlink
OPENOCD = ${TOOLS_ROOT}/Windows/openocd

# Variable
LD_LIBRARY_PATH="$LD_LIBRARY_PATH":$(STLINK)/lib
	export LD_LIBRARY_PATH

# debuger flags
GDBFLAGS = -q -iex "set auto-load safe-path /"
