
######################################################################
#                         SETUP TARGETS                              #
######################################################################

# Print short name by default
NAME = $@
ifdef FN
    NAME = $^
endif

.PHONY: all debug

all: $(PROJ_NAME).elf

%.o : %.c
	@echo "[Compiling  ] $(NAME)"
	@$(CC) -c -o $@ $(INCLUDE) $(DEFS) $(CFLAGS) $^

%.o : %.s
	@echo "[Assembling ] $(NAME)"
	@$(AS) $(AFLAGS) $< -o $@

$(PROJ_NAME).elf: $(OBJS)
	@echo "[Linking    ] $@"
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

# connect to device
stcon:
	$(STLINK)/bin/st-util -p 3333

# connect to device
ocdcon:
	$(OPENOCD)/bin/openocd -f interface/stlink-v2.cfg -f board/stm32f4discovery.cfg

gdb:
# before you start gdb, you must start st-util --tui 
	$(GDB) $(PROJ_NAME).elf -q