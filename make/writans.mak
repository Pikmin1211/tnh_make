
text := $(realpath .)/text
text_entries := $(text)/.TextEntries
text_files := $(text)/textfiles

text_buildfile := $(text)/text_buildfile.txt
text_installer := $(text)/InstallTextData.event
text_definitions := $(text)/TextDefinitions.event
parse_definitions := $(text)/ParseDefinitions.txt
all_text := $(shell find $(text_files) -type f -name "*.txt")

# text buildfile to installer and definitions
$(text_installer) $(text_definitions): $(text_buildfile) $(all_text) $(parse_definitions)
	$(notify)
	$(make_dir)
	@python3 $(text_process) $(text_buildfile) \
	--installer $(text_installer) --definitions $(text_definitions) \
	--parser-exe $(parsefile) --parse-definitions $(parse_definitions)
