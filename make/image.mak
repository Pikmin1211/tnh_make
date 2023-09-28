
pic := $(img)/pic
pic_bin := $(bin)/pic

pic_pngs := $(shell find $(pic) -type f -name "*.png")
pic_bins := $(patsubst $(pic)/%.png, $(pic_bin)/%.bin, $(pic_pngs))

# png to bin
$(pic_bin)/%.bin: $(pic)/%.png
	$(notify)
	$(make_dir)
	@$(png2dmp) $^ -o $@

cmp := $(img)/cmp
cmp_bin := $(bin)/cmp

cmp_pngs := $(shell find $(cmp) -type f -name "*.png")
cmp_bins := $(patsubst $(cmp)/%.png, $(cmp_bin)/%.bin, $(cmp_pngs))

# png to compressed bin
$(cmp_bin)/%.bin: $(cmp)/%.png
	$(notify)
	$(make_dir)
	@$(png2dmp) $^ -o $@ --lz77
