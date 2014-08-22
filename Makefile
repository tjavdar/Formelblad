# Makefle för formelblad
# Sätt AMNE = an|la|tr|fv|mv för respektive formelblad 
# 2011-03-11: No more intermediate dvi

AMNE         := Tables
AMNE         := st

# Övriga Makefile-vars # <<<
ALLMATTEDIR  := ../allmatte
BNAME        := formelblad
FILE         := $(BNAME)-$(AMNE)
EDIT          := gvim
PS2PDF        := ps2pdfwr -dCompatibilityLevel=1.4 -sPAPERSIZE=a4
PDFNUP        := pdfnup --frame true --a4paper
MTABLES       := $(wildcard *.m)
TEXTABLES     := $(patsubst %.m,%.tex,$(MTABLES))
x2_LPOPTIONS:= -o media=A4 -o fit-to-page -o sides=two-sided-short-edge -o landscape
LANG0      := Lang=0\\relax
LANG1      := Lang=1\\relax
# >>>
#
# Implicit rules# <<<

%.dvi : %.tex
	if [ -f $*.sh ]; then sh $*.sh; fi # fig-script if present
	latex $< ; latex $<


%.pdf : %.tex
	pdflatex $<

%-x2.pdf : %.pdf
	$(PDFNUP) --suffix x2 $< 

%-x4.pdf : %.pdf
	$(PDFNUP) --nup 2x2 --no-landscape --suffix x4 $< 

%.tex : %.m
	octave -q $< > $@

# End of implicit rules# >>>

# Rules # <<<
default : c

c:    $(FILE).pdf

ec:
	vim $(FILE).tex 
et:
	lxterminal -e vim $(FILE).tex &
e:
	$(EDIT) $(FILE).tex &

x2 : $(FILE)-x2.pdf

x4 : $(FILE)-x4.pdf

v:
	evince $(FILE).pdf &
v2:
	evince $(FILE)-x2.pdf &
v4:
	evince $(FILE)-x4.pdf &

p:
	lp $(FILE).pdf
p2:
	lp $(x2_LPOPTIONS) $(FILE)-x2.pdf
p4:
	lp $(FILE)-x4.pdf



# Special rules

tables: $(TEXTABLES)

www: $(FILE).pdf $(FILE)-x2.pdf $(FILE)-x4.pdf
	rsync -auv *.tex *.pdf $(ALLMATTEDIR)/formelblad/
	@echo; echo Consider to:
	@echo; echo "        pushd $(ALLMATTEDIR); make  www; popd"; echo

en: 
	sed -i'~' 's,^\\Lang=[0-9],\\Lang=0,' $(FILE).tex # Reload file!
sv: 
	sed -i'~' 's,^\\Lang=[0-9],\\Lang=1,' $(FILE).tex # Reload file!

sl:  $(FILE).tex
	# Swap Lang 0<->1 (sv<->en):
	# TentaSwap: TentaVariant 0<->1
	@sed -i'~' 's/$(LANG1)/$(LANG0)/; t End; s/$(LANG0)/$(LANG1)/; :End' $<
	@grep -E '$(LANG0)|$(LANG1)' $<

help : 
	@echo "Usage:"
	@echo "Put AMNE = an|la|tr|fv|mv for corresponding formelblad "
	@echo "Just make  || make www "

cl: clean
clean:
	rm -f .log *.aux *.log *.dvi *.bak *.ps foo* *.gpg *~ 
# >>>
