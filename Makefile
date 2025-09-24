# --------------------------------
# Command pre-requisites
# --------------------------------
ifeq ($(OS),Windows_NT)
  FIND_EXEC = where
else
  FIND_EXEC = command -v
endif

REQUIRES = pdflatex bibtex
$(foreach exec,$(REQUIRES),\
  $(if $(shell $(FIND_EXEC) $(exec)),,\
       $(error "Required command '$(exec)' not found in PATH")))

GS ?= gs
OPTIONAL = $(GS)
$(foreach tool,$(OPTIONAL),\
  $(eval HAS_$(shell echo $(tool) | tr a-z A-Z) := $(shell $(FIND_EXEC) $(tool) >/dev/null 2>&1 && echo yes)))

$(foreach tool,$(OPTIONAL),\
  $(if $(value HAS_$(shell echo $(tool) | tr a-z A-Z)),,\
       $(warning Optional command '$(tool)' not found – related steps will be skipped)))

# --------------------------------
# Dependencies and Targets
# --------------------------------
DEPS := $(shell find assets conf content metadata targets templates -type f \( -name '*.pdf' -o -name '*.png' -o -name '*.jpg' -o -name '*.tex' -o -name '*.bst' -o -name '*.cls' \))
TARGETS_PATH    = targets
BUILD_PATH      = build

targets := siggraph-internal\
           siggraph-submission\
	   siggraph-revision\
	   siggraph-camready\
	   siggraph-camauthor\
	   dissertation
targets-split := $(foreach target,$(targets), $(target)-split)

.PHONY: all demo clean $(targets) $(targets-split)
# Prevent make deleting intermediate pdf files
.SECONDARY:

# --------------------------------
# Recipes
# --------------------------------

all: $(targets-split)

demo: $(BUILD_PATH)/siggraph-internal.supplement.compressed.pdf
	cp $(BUILD_PATH)/siggraph-internal.supplement.compressed.pdf HOWTO.pdf

$(targets): %: $(BUILD_PATH)/%.all.compressed.pdf

$(targets-split): %-split: $(BUILD_PATH)/%.manuscript.compressed.pdf\
                           $(BUILD_PATH)/%.supplement.compressed.pdf\
   	                   $(BUILD_PATH)/%.all.compressed.pdf

%.compressed.pdf : %.pdf
ifeq ($(HAS_GS),yes)
	$(GS) -sDEVICE=pdfwrite -dCompatibilityLevel=1.5 -dNOPAUSE -dQUIET -dBATCH -dPrinted=false -sOutputFile=$*.compressed.pdf $*.pdf
else
	@echo "[skip] $(GS) not installed. Skipping $@"
endif

%.supplement.pdf : %.manuscript.pdf %.all.pdf
ifeq ($(HAS_GS),yes)
	$(GS) -dNOPAUSE -dQUIET -dBATCH -sOutputFile="$*.supplement.pdf" -dFirstPage=$$(echo $$($(GS) -q -dNODISPLAY -dNOSAFER -c "($*.manuscript.pdf) (r) file runpdfbegin pdfpagecount = quit") + 1 | bc) -dLastPage=$$($(GS) -q -dNODISPLAY -dNOSAFER -c "($*.all.pdf) (r) file runpdfbegin pdfpagecount = quit") -sDEVICE=pdfwrite "$*.all.pdf"
else
	@echo "[skip] $(GS) not installed. Skipping $@"
endif

%.manuscript.pdf : %.all.pdf
	# First generate support files
	cat $(TARGETS_PATH)/$(*F).tex | sed 's/^.*\\\includeonly{}/% \\\includeonly{}/' > $(TARGETS_PATH)/$(*F).manuscript.tex
	pdflatex -interaction=nonstopmode -halt-on-error -jobname=$*.manuscript $(TARGETS_PATH)/$(*F).manuscript.tex
	# Remove supplement section
	cat $(TARGETS_PATH)/$(*F).tex | sed 's/^.*\\\includeonly{}/\\\includeonly{}/' > $(TARGETS_PATH)/$(*F).manuscript.tex
	pdflatex -interaction=nonstopmode -halt-on-error -jobname=$*.manuscript $(TARGETS_PATH)/$(*F).manuscript.tex
	-bibtex $*.manuscript.aux || true
	pdflatex -interaction=nonstopmode -halt-on-error -jobname=$*.manuscript $(TARGETS_PATH)/$(*F).manuscript.tex
	pdflatex -interaction=nonstopmode -halt-on-error -jobname=$*.manuscript $(TARGETS_PATH)/$(*F).manuscript.tex
	# Clean-up temporary files
	rm -f $(TARGETS_PATH)/$(*F).manuscript.tex

%.all.pdf : $(DEPS)
	mkdir -p $(BUILD_PATH)
	pdflatex -interaction=nonstopmode -halt-on-error -jobname=$*.all $(TARGETS_PATH)/$(*F).tex
	-bibtex $*.all.aux || true
	pdflatex -interaction=nonstopmode -halt-on-error -jobname=$*.all $(TARGETS_PATH)/$(*F).tex
	pdflatex -interaction=nonstopmode -halt-on-error -jobname=$*.all $(TARGETS_PATH)/$(*F).tex

clean:
	rm -rf $(BUILD_PATH)
	rm comment.cut