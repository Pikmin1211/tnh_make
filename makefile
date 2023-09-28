
notify = @echo "$(notdir $^) => $(notdir $@)"
make_dir = @mkdir -p $(dir $@)

rom_clean := $(realpath .)/tnh.gba
rom_hack := $(realpath .)/tnh_en.gba
buildfile := $(realpath .)/buildfile.event

bin := $(realpath .)/bin
event := $(realpath .)/event
img := $(realpath .)/img
make := $(realpath .)/make

include $(make)/tools.mak
include $(make)/fonts.mak
include $(make)/wizardry.mak
include $(make)/writans.mak
include $(make)/image.mak

hack: $(rom_hack)

$(rom_hack): $(rom_clean) $(buildfile) $(event_depends)
	@echo building $(rom_hack)
	@cp -f $(rom_clean) $(rom_hack)
	@$(core) A FE8 -output:$(rom_hack) -input:$(buildfile) $(ea_flags) || (rm -f $(rom_hack) $(rom_hack:.gba=.sym) && false)

#@cat "$(rom_clean:.gba=.sym)" >> "$(rom_hack:.gba=.sym)" || true

clean_files := \
$(rom_hack) $(rom_hack:.gba=.sym) $(rom_hack:.gba=.sav) \
$(text_installer) $(text_definitions)

clean_dirs := \
$(bin) $(event) \
$(text_entries)

clean:
	@rm -f $(clean_files)
	@rm -rf $(clean_dirs)
	@echo all clean!
