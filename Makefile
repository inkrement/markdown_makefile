# TODO
# - inlcude template

SOURCE := src
BUILD_DIR := build

## Markdown extension (e.g. md, markdown, mdown).
MEXT = md

# path to source
MARKDOWN := $(wildcard $(SOURCE)/*.$(MEXT))
PDF := $(patsubst %.$(MEXT), %.pdf, $(subst $(SOURCE), $(BUILD_DIR), $(MARKDOWN))) 

# path to templates
PREFIX = ./pandoc-templates

# ulysses diplarbeit
UDSRC=/Users/chris/Library/Mobile\ Documents/X5AZV975AG~com~soulmen~ulysses3/Documents/Library/Groups-ulgroup/15e14e3169a24d1da8e0086dfb0cf495-ulgroup/8f4a52fff5cd4bbcaeae0e5dd2f37dc5-ulgroup

BIB = /Users/chris/Documents/mendeley/library.bib

CSL = apsa

#PDFS=$(SRC:.md=.pdf)

all:	checkdirs $(PDF)
checkdirs: $(BUILD_DIR)
$(BUILD_DIR):
	@mkdir -p $@

pdf:	clean fetch $(PDF)

fetch:
	./xml_extract_md.sh  $(UDSRC) > ./src/diplomarbeit.md

$(BUILD_DIR)/%.pdf: $(SOURCE)/%.md
	pandoc -r markdown+simple_tables+table_captions+yaml_metadata_block \
		-s -S --latex-engine=xelatex \
		--template=$(PREFIX)/templates/xelatex.template \
		--filter pandoc-citeproc \
		--csl=$(PREFIX)/csl/$(CSL).csl \
		--bibliography=$(BIB) -o $@ $<
	open $@


clean:
	rm -f ./$(BUILD_DIR)/*

.PHONY: all clean fetch pdf checkdirs