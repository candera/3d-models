# To use this, make a file called `base.scad` with all your models in
# it. Mark any of them you want to be able to render independently
# with "export", as follows:
#
# module foobar() { // export
#  body_of_module();
# }
#
# You will now be able to run `make foobar.generated.stl` and it'll do the right
# thing as far as figuring out dependencies and not rebuilding too
# often. It does this by generating foobar.scad and foobar.deps, which
# you probably don't want to check in.

# match "module foobar() { // export
TARGETS=$(shell sed '/^module [a-z0-9_-].*().*export/!d;s/module //;s/().*/.generated.stl/' base.scad)

.PHONY: clean

all: ${TARGETS}

# auto-generated .scad files with .deps make make re-build always. keeping the
# scad files solves this problem. (explanations are welcome.)
.SECONDARY: $(shell echo "${TARGETS}" | sed 's/\.stl/.scad/g')

# explicit wildcard expansion suppresses errors when no files are found
include $(wildcard *.deps)

%.scad:
	$(shell echo 'use <base.scad>\n$(subst .generated,,$*)();' > $@)

%.stl: %.scad
	openscad -m make -o $@ -d $@.deps $<

clean:
	rm *.generated.*
