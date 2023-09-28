
tools := $(realpath .)/tools
elucidator := $(tools)/elucidator
grit := $(DEVKITPRO)/tools/bin/grit

ea := $(tools)/eventassembler
core := $(ea)/ColorzCore
ea_flags := --nocash-sym
ea_tools := $(ea)/Tools
eadep := $(ea)/ea-dep
event_depends := $(shell $(eadep) $(buildfile) -I $(ea) --add-missings)

fe_pytools := $(tools)/fe-pytools

text_process := $(fe_pytools)/text-process-classic.py
parsefile := $(ea_tools)/ParseFile

png2dmp := $(ea_tools)/Png2Dmp
