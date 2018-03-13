LATEXMK    = latexmk
LATEXMKOPT = -xelatex -shell-escape

MAIN       := document
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

all: $(MAIN).pdf

.refresh:
	touch .refresh

$(MAIN).pdf: .refresh $(SRCS)
	mkdir -p ../$(OUTDIR)/
	cd $(SRCDIR)/ && \
		$(LATEXMK) $(LATEXMKOPT) \
			-output-directory=../$(OUTDIR) \
			$(MAIN)
	cp $(OUTDIR)/$(MAIN).pdf $(MAIN).pdf

bib: clean-bib $(SRCBIB)

$(SRCBIB):
	curl https://researchr.org/downloadbibtex/bibliography/b0402c72-980f-6580-6b0e-7a614ed2d64c-master-thesis/compact -o $(SRCBIB)
	sed -i '1 s/^/% /' $(SRCBIB)


clean-bib:
	rm -f $(SRCBIB)

clean: clean-bib
	rm -rf $(OUTDIR)/
	rm -f *.pdf
	rm -f *.aux
	rm -f *.fdb_latexmk
	rm -f *.fls

show: view
view: all
	xdg-open $(MAIN).pdf
