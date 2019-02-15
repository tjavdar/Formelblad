MTABLES = $(wildcard *.m)
TTABLES = $(MTABLES:.m=.tex)
TABLE = test

1st: $(TTABLES)
	#
	# Made all tables in $(notdir $(PWD)).
	#

%.tex: %.m
	octave-cli -q $<  >  $@


t: $(TABLE).pdf
$(TABLE).pdf: $(TABLE).tex $(TTABLES)
	latexmk -pdf -quiet $<
	zathura  $@ 2>/dev/null &

e:
	nvim $(TABLE).tex

cl clean:
	latexmk -C 2> /dev/null
