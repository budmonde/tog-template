TARGETS    = targets
BUILD      = build

.PHONY: all internal submission revision camready camauthor clean

all: internal submission revision camready camauthor

internal:   $(BUILD)/internal.manuscript.compressed.pdf\
            $(BUILD)/internal.supplement.compressed.pdf\
	    $(BUILD)/internal.all.compressed.pdf

submission: $(BUILD)/submission.manuscript.compressed.pdf\
            $(BUILD)/submission.supplement.compressed.pdf\
	    $(BUILD)/submission.all.compressed.pdf

revision:   $(BUILD)/revision.manuscript.compressed.pdf\
            $(BUILD)/revision.supplement.compressed.pdf\
	    $(BUILD)/revision.all.compressed.pdf

camready:   $(BUILD)/camready.manuscript.compressed.pdf\
            $(BUILD)/camready.supplement.compressed.pdf\
	    $(BUILD)/camready.all.compressed.pdf

camauthor:  $(BUILD)/camauthor.manuscript.compressed.pdf\
            $(BUILD)/camauthor.supplement.compressed.pdf\
	    $(BUILD)/camauthor.all.compressed.pdf

%.compressed.pdf : %.pdf
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.5 -dNOPAUSE -dQUIET -dBATCH -dPrinted=false -sOutputFile=$*.compressed.pdf $*.pdf

%.supplement.pdf : %.manuscript.pdf %.all.pdf
	gs -dNOPAUSE -dQUIET -dBATCH -sOutputFile="$*.supplement.pdf" -dFirstPage=$$(echo $$(gs -q -dNODISPLAY -dNOSAFER -c "($*.manuscript.pdf) (r) file runpdfbegin pdfpagecount = quit") + 1 | bc) -dLastPage=$$(gs -q -dNODISPLAY -dNOSAFER -c "($*.all.pdf) (r) file runpdfbegin pdfpagecount = quit") -sDEVICE=pdfwrite "$*.all.pdf"

%.manuscript.pdf : %.all.pdf
	# Make manuscript version of paper.tex
	cat $(TARGETS)/$(*F).tex | sed 's/\\\input{paper}/\\\input{paper.manuscript}/' > $(TARGETS)/$(*F).manuscript.tex
	# First generate support files
	cat paper.tex | sed 's/^.*\\\includeonly{}/% \\\includeonly{}/' > paper.manuscript.tex
	pdflatex -jobname=$*.manuscript $(TARGETS)/$(*F).manuscript.tex
	# Remove supplement section
	cat paper.tex | sed 's/^.*\\\includeonly{}/\\\includeonly{}/' > paper.manuscript.tex
	pdflatex -jobname=$*.manuscript $(TARGETS)/$(*F).manuscript.tex
	bibtex $*.manuscript.aux
	pdflatex -jobname=$*.manuscript $(TARGETS)/$(*F).manuscript.tex
	pdflatex -jobname=$*.manuscript $(TARGETS)/$(*F).manuscript.tex
	# Clean-up temporary files
	rm -f paper.manuscript.tex $(TARGETS)/$(*F).manuscript.tex

%.all.pdf :
	mkdir -p $(BUILD)
	pdflatex -jobname=$*.all $(TARGETS)/$(*F).tex
	bibtex $*.all.aux
	pdflatex -jobname=$*.all $(TARGETS)/$(*F).tex
	pdflatex -jobname=$*.all $(TARGETS)/$(*F).tex

clean:
	rm -rf $(BUILD)
