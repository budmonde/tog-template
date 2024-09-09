REQUIRES = pdflatex gs
TMP := $(foreach exec,$(REQUIRES), $(if $(shell which $(exec)),some string,$(error "No '$(exec)' in PATH")))

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

all: $(targets-split)

demo: $(BUILD_PATH)/siggraph-camready.supplement.compressed.pdf
	cp $(BUILD_PATH)/siggraph-camready.supplement.compressed.pdf HOWTO.pdf

$(targets): %: $(BUILD_PATH)/%.all.compressed.pdf

$(targets-split): %-split: $(BUILD_PATH)/%.manuscript.compressed.pdf\
                           $(BUILD_PATH)/%.supplement.compressed.pdf\
   	                   $(BUILD_PATH)/%.all.compressed.pdf

%.compressed.pdf : %.pdf
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.5 -dNOPAUSE -dQUIET -dBATCH -dPrinted=false -sOutputFile=$*.compressed.pdf $*.pdf

%.supplement.pdf : %.manuscript.pdf %.all.pdf
	gs -dNOPAUSE -dQUIET -dBATCH -sOutputFile="$*.supplement.pdf" -dFirstPage=$$(echo $$(gs -q -dNODISPLAY -dNOSAFER -c "($*.manuscript.pdf) (r) file runpdfbegin pdfpagecount = quit") + 1 | bc) -dLastPage=$$(gs -q -dNODISPLAY -dNOSAFER -c "($*.all.pdf) (r) file runpdfbegin pdfpagecount = quit") -sDEVICE=pdfwrite "$*.all.pdf"

%.manuscript.pdf : %.all.pdf
	# First generate support files
	cat $(TARGETS_PATH)/$(*F).tex | sed 's/^.*\\\includeonly{}/% \\\includeonly{}/' > $(TARGETS_PATH)/$(*F).manuscript.tex
	pdflatex -jobname=$*.manuscript $(TARGETS_PATH)/$(*F).manuscript.tex
	# Remove supplement section
	cat $(TARGETS_PATH)/$(*F).tex | sed 's/^.*\\\includeonly{}/\\\includeonly{}/' > $(TARGETS_PATH)/$(*F).manuscript.tex
	pdflatex -jobname=$*.manuscript $(TARGETS_PATH)/$(*F).manuscript.tex
	bibtex $*.manuscript.aux
	pdflatex -jobname=$*.manuscript $(TARGETS_PATH)/$(*F).manuscript.tex
	pdflatex -jobname=$*.manuscript $(TARGETS_PATH)/$(*F).manuscript.tex
	# Clean-up temporary files
	rm -f $(TARGETS_PATH)/$(*F).manuscript.tex

%.all.pdf :
	mkdir -p $(BUILD_PATH)
	pdflatex -jobname=$*.all $(TARGETS_PATH)/$(*F).tex
	bibtex $*.all.aux
	pdflatex -jobname=$*.all $(TARGETS_PATH)/$(*F).tex
	pdflatex -jobname=$*.all $(TARGETS_PATH)/$(*F).tex

clean:
	rm -rf $(BUILD_PATH)
	rm comment.cut
