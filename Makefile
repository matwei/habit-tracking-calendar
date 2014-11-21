YEAR = 2011
CAL = kalender$(YEAR)

%.dvi: %.tex; latex $<

%.ps: %.dvi; dvips $<

%.pdf: %.ps; ps2pdf $<

$(CAL).pdf:	$(CAL).tex
	latex $(CAL).tex
	dvips $(CAL).dvi
	ps2pdf $(CAL).ps
	rm -f $(CAL).aux $(CAL).dvi $(CAL).log $(CAL).ps $(CAL).tex

clean:
	rm -f $(CAL).aux $(CAL).dvi $(CAL).log $(CAL).ps

distclean: clean
	rm -f $(CAL).pdf $(CAL).tex


$(CAL).tex:
	./kalender.lua $(YEAR) > $(CAL).tex
