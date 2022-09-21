FINAL = out_final
DRAFT = out_draft

.PHONY: clean

all: final draft

final: $(FINAL).manuscript.compressed.pdf $(FINAL).supplement.compressed.pdf $(FINAL).all.compressed.pdf
draft: $(DRAFT).manuscript.compressed.pdf $(DRAFT).supplement.compressed.pdf $(DRAFT).all.compressed.pdf

%.compressed.pdf : %.pdf
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.5 -dNOPAUSE -dQUIET -dBATCH -dPrinted=false -sOutputFile=$*.compressed.pdf $*.pdf

%.supplement.pdf : %.manuscript.pdf %.all.pdf
	gs -dNOPAUSE -dQUIET -dBATCH -sOutputFile="$*.supplement.pdf" -dFirstPage=$$(echo $$(gs -q -dNODISPLAY -dNOSAFER -c "($*.manuscript.pdf) (r) file runpdfbegin pdfpagecount = quit") + 1 | bc) -dLastPage=$$(gs -q -dNODISPLAY -dNOSAFER -c "($*.all.pdf) (r) file runpdfbegin pdfpagecount = quit") -sDEVICE=pdfwrite "$*.all.pdf"

%.manuscript.pdf : %.all.pdf
	# Make manuscript version of paper.tex
	cat $*.tex | sed 's/\\\input{paper}/\\\input{paper.manuscript}/' > $*.manuscript.tex
	# First generate support files
	cat paper.tex | sed 's/^.*\\\includeonly{}/% \\\includeonly{}/' > paper.manuscript.tex
	pdflatex -jobname=$*.manuscript $*.manuscript.tex
	# Remove supplement section
	cat paper.tex | sed 's/^.*\\\includeonly{}/\\\includeonly{}/' > paper.manuscript.tex
	pdflatex -jobname=$*.manuscript $*.manuscript.tex
	bibtex $*.manuscript.aux
	pdflatex -jobname=$*.manuscript $*.manuscript.tex
	pdflatex -jobname=$*.manuscript $*.manuscript.tex
	# Clean-up temporary files
	rm -f paper.manuscript.tex $*.manuscript.tex

%.all.pdf :
	pdflatex -jobname=$*.all $*.tex
	bibtex $*.all.aux
	pdflatex -jobname=$*.all $*.tex
	pdflatex -jobname=$*.all $*.tex

clean:
	rm -f *.blg *.bbl *.aux *.log *.out *.cut
	rm -f *.all.compressed.pdf *.all.pdf
	rm -f *.all-support.tex
	rm -f *.manuscript.compressed.pdf *.manuscript.pdf
	rm -f *.manuscript-support.tex
	rm -f *.supplement.compressed.pdf *.supplement.pdf
