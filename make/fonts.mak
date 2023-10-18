
font_png := $(img)/font
font_bin := $(bin)/font

item_font_png := $(font_png)/item
item_font_bin := $(font_bin)/item
item_font_pngs := $(shell find $(item_font_png) -type f -name "*.png")
item_font_bins := $(patsubst $(item_font_png)/%.png, $(item_font_bin)/%.bin, $(item_font_pngs))

serif_font_png := $(font_png)/serif
serif_font_bin := $(font_bin)/serif
serif_font_pngs := $(shell find $(serif_font_png) -type f -name "*.png")
serif_font_bins := $(patsubst $(serif_font_png)/%.png, $(serif_font_bin)/%.bin, $(serif_font_pngs))

item_font_installer := $(event)/item_font_installer.event
serif_font_installer := $(event)/serif_font_installer.event
font_import := $(elucidator)/FontImport/FontImport.py
font_settings := -gb -gB 2 -u8 -p! -fh!

# font png to bin
$(font_bin)/%.bin: $(font_png)/%.png
	$(notify)
	$(make_dir)
	@$(grit) $^ $(font_settings) -o $@
	@mv $(basename $@).img.bin $@

# item font installer
$(item_font_installer): $(item_font_pngs) $(item_font_bins)
	$(notify)
	$(make_dir)
	@python3 $(font_import) --input $(item_font_bins) --input-image $(item_font_pngs) --output $(item_font_installer) --relative-path $(realpath .)/event --name "item"

# serif font installer
$(serif_font_installer): $(serif_font_pngs) $(serif_font_bins)
	$(notify)
	$(make_dir)
	@python3 $(font_import) --input $(serif_font_bins) --input-image $(serif_font_pngs) --output $(serif_font_installer) --relative-path $(realpath .)/event --name "serif" --width 1
