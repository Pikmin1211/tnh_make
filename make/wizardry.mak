
src := $(realpath .)/src
src_bin := $(bin)/src

source_files := $(shell find $(src) -type f -name "*.asm")
source_bins := $(patsubst $(src)/%.asm, $(src_bin)/%.bin, $(source_files))

include $(DEVKITARM)/base_tools

# include flags
include_dirs := 
incflags := $(foreach dir, $(include_dirs), -I "$(dir)")

# compilation flags
arch := -mcpu=arm7tdmi -mthumb -mthumb-interwork
cflags := $(arch) $(incflags) -Wall -O2 -mtune=arm7tdmi -ffreestanding -fomit-frame-pointer -mlong-calls
asflags := $(arch) $(incflags)

# asm to obj
%.o: %.asm
	$(notify)
	$(make_dir)
	@$(AS) $(asflags) -I $(dir $<) $< -o $@

# obj to bin
$(src_bin)/%.bin: $(src)/%.o
	$(notify)
	$(make_dir)
	@$(OBJCOPY) -S $< -O binary $@
