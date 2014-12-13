# Makefle för formelblad
# Sätt AMNE = an|la|tr|fv|mv för respektive formelblad 
# 2011-03-11: No more intermediate dvi

AMNE         := Tables
AMNE         := fv

# Övriga Makefile-vars # <<<
ALLMATTEDIR   := ../allmatte
WWWDIR        := ../allmatte/formelblad
BNAME         := formelblad
FILE          := $(BNAME)-$(AMNE)
EDIT          := gvim
PS2PDF        := ps2pdfwr -dCompatibilityLevel=1.4 -sPAPERSIZE=a4
PDFNUP        := pdfnup --frame true --a4paper
x2_LPOPTIONS:= -o media=A4 -o fit-to-page -o sides=two-sided-short-edge -o landscape
LANG0      := Lang=0\\relax
LANG1      := Lang=1\\relax
# >>>
#
# Implicit rules# <<<

%.pdf-bloat : %.tex
	pdflatex $<
	pdflatex $<
	mv -fv $*.pdf $@    # GNU Make Automatic var $$*!

%-x2.pdf-bloat : %.pdf
	$(PDFNUP) --suffix x2 $< --outfile $@

%-x4.pdf-bloat : %.pdf
	$(PDFNUP) --nup 2x2 --no-landscape --suffix x4 $< --outfile $@

%.pdf : %.pdf-bloat
	@echo Squeezing $< ...
	@ps2pdfwr -dCompatibilityLevel=1.4 $<  $@
	@echo "Compare sizes non-squeezed/squeezed:"
	@ls -l  $<  $@

%.tex : %.m
	octave -q $< > $@

$(WWWDIR)/%.pdf : %.pdf
	rsync -auv  $< $@

# End of implicit rules# >>>

# Rules # <<<

default : x

ec:
	vim $(FILE).tex 
et:
	lxterminal -e vim $(FILE).tex &
e:
	$(EDIT) $(FILE).tex &

x  : $(FILE).pdf
xr : $(WWWDIR)/$(FILE).pdf
x2r: $(WWWDIR)/$(FILE)-x2.pdf
x4r: $(WWWDIR)/$(FILE)-x4.pdf

v:
	evince $(FILE).pdf &
p:
	lp $(FILE).pdf
p2:
	lp $(x2_LPOPTIONS) $(FILE)-x2.pdf
p4:
	lp $(FILE)-x4.pdf

# Special rules

tables: $(TEXTABLES)

www: xr x2r x4r
	@echo; echo Created and moved:
	@ls -oh $(WWWDIR)/$(FILE)*pdf
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
	@echo "make || make www "

cl: clean

clean:
	rm -f *.pdf .log *.aux *.log *.dvi *.bak *.ps foo* *.gpg *~ 
