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

# clean firmware & object files
clean:
	rm -f *.o $(PROJ_NAME).elf $(PROJ_NAME).hex $(PROJ_NAME).bin

# write firmware into controller 
stflash: all
	$(STLINK)/bin/st-flash write $(PROJ_NAME).bin 0x8000000

# write firmware into controller 
ocdflash: all 
	$(OPENOCD)/bin/openocd -f interface/stlink-v2.cfg -f board/stm32f4discovery.cfg -c "init" -c "reset init" -c "flash write_image erase $(PROJ_NAME).hex" -c "reset" -c "shutdown"

# connect to device
stcon:
	$(STLINK)/bin/st-util -m -p 3333

# connect to device
ocdcon:
	$(OPENOCD)/bin/openocd -f interface/stlink-v2.cfg -f board/stm32f4discovery.cfg

# debug target
gdb:
# before you start gdb, you must start st-util --tui 
	$(GDB) $(PROJ_NAME).elf $(GDBFLAGS)
