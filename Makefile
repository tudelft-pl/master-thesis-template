LATEXMK    = latexmk
LATEXMKOPT = -xelatex -bibtex -shell-escape -synctex=1 -interaction=nonstopmode -file-line-error
CONTINUOUS = -pvc -view=default -halt-on-error

DOCUMENT   := document
OUTPUT     := $(DOCUMENT)
RESEARCHR  := b0402c72-980f-6580-6b0e-7a614ed2d64c-master-thesis
SRCDIR     := src
FIGDIR     := src/fig
IMGDIR     := src/img
RESDIR     := src/res
OUTDIR     := out
SRCBIB     := $(SRCDIR)/researchr.bib
SRCS       := Makefile $(wildcard $(SRCDIR)/*.tex) $(shell find $(FIGDIR)/* $(IMGDIR)/* $(RESDIR)/* -type f) $(SRCBIB)
IMGS       := $(wildcard $(IMGDIR)/*.ps) $(wildcard $(IMGDIR)/*.eps)
OBJS       := $(wildcard $(OUTDIR)/*.aux) $(wildcard $(OUTDIR)/*.bbl) $(wildcard $(OUTDIR)/*.pdf)

.PHONY: all clean .refresh view show bib clean-bib

all: $(DOCUMENT).pdf

.refresh:
	touch .refresh

$(DOCUMENT).pdf: .refresh $(SRCS)
	mkdir -p ../$(OUTDIR)/
	cd $(SRCDIR)/ && \
		$(LATEXMK) $(LATEXMKOPT) \
			-output-directory=../$(OUTDIR) \
			$(DOCUMENT)
	mv $(OUTDIR)/$(DOCUMENT).pdf $(OUTPUT).pdf
	-mv $(OUTDIR)/$(DOCUMENT).vtc $(OUTPUT).vtc
	-mv $(OUTDIR)/$(DOCUMENT).synctex.gz $(OUTPUT).synctex.gz

watch:
	mkdir -p ../$(OUTDIR)/
	cd $(SRCDIR)/ && \
		$(LATEXMK) $(LATEXMKOPT) $(CONTINUOUS) \
			-output-directory=../$(OUTDIR) \
			$(DOCUMENT)

bib: clean-bib $(SRCBIB) fix-bib

$(SRCBIB):
	curl https://researchr.org/downloadbibtex/bibliography/$(RESEARCHR)/compact -o $(SRCBIB)

fix-bib: $(SRCBIB)
	sed -i '' '1 s/^/% /' $(SRCBIB)
	sed -i '' 's/doi = {http.*\/\(10\..*\)}/doi = {\1}/' $(SRCBIB)
	sed -i '' '/doi = {http.*}/d' $(SRCBIB)

clean-bib:
	rm -f $(SRCBIB)

clean: clean-bib
	rm -rf $(OUTDIR)/
	rm -f *.aux
	rm -f *.bbl
	rm -f *.blg
	rm -f *.fdb_latexmk
	rm -f *.fls
	rm -f *.log
	rm -f *.out
	rm -f *.pdf
	rm -f *.swp
	rm -f *.synctex.gz
	rm -f *.vtc
	rm -f src/*.aux
	rm -f src/*.bbl
	rm -f src/*.blg
	rm -f src/*.fdb_latexmk
	rm -f src/*.fls
	rm -f src/*.log
	rm -f src/*.out
	rm -f src/*.pdf
	rm -f src/*.swp
	rm -f src/*.synctex.gz
	rm -f src/*.vtc


show: view
view: all
	open $(OUTPUT).pdf
