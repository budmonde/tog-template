FINAL = out_final
DRAFT = out_draft

all: final draft

.PHONY: clean

final: $(FINAL).compressed.pdf
draft: $(DRAFT).compressed.pdf

$(FINAL).compressed.pdf : $(FINAL).pdf
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.5 -dNOPAUSE -dQUIET -dBATCH -dPrinted=false -sOutputFile=$(FINAL).compressed.pdf $(FINAL).pdf

$(DRAFT).compressed.pdf : $(DRAFT).pdf
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.5 -dNOPAUSE -dQUIET -dBATCH -dPrinted=false -sOutputFile=$(DRAFT).compressed.pdf $(DRAFT).pdf

$(FINAL).pdf :
	pdflatex $(FINAL).tex
	bibtex $(FINAL).aux
	pdflatex $(FINAL).tex
	pdflatex $(FINAL).tex

$(DRAFT).pdf :
	pdflatex $(DRAFT).tex
	bibtex $(DRAFT).aux
	pdflatex $(DRAFT).tex
	pdflatex $(DRAFT).tex

clean:
	rm -f *.blg *.bbl *.aux *.log *.out
	rm -f $(FINAL).compressed.pdf $(FINAL).pdf $(FINAL).out $(FINAL).dvi
	rm -f $(FINAL)-support.tex comment.cut
	rm -f $(DRAFT).compressed.pdf $(DRAFT).pdf $(DRAFT).out $(DRAFT).dvi
	rm -f $(DRAFT)-support.tex comment.cut
