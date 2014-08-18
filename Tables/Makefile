TARGETS = $(patsubst %.m,%.tex,$(wildcard *.m))

%.tex : %.m
	  cat $< | octave -q  > $@

default: $(TARGETS)

e:
	# Launching editor for last touched source
	gvim $$(ls -t *.m 2>/dev/null | head -n1)

cl: clean
clean:
	rm -f .log *.aux *.log *.dvi *.bak *.ps foo* *~ 
