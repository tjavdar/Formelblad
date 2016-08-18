# Makefle för formelblad
# 2016-08-08: More include files/common targets and rules
# 2015-01-28: file to be done is the LAST-touched, unless explicitly defined
# 2011-03-11: No more intermediate dvi

# Övriga Makefile-vars # <<<
ALLMATTEDIR   := ../allmatte
WWWDIR        := ../allmatte/formelblad
BNAME         := formelblad
PS2PDF        := ps2pdfwr -dCompatibilityLevel=1.4 -sPAPERSIZE=a4
PDFNUP        := pdfnup --frame true --a4paper
x2_LPOPTIONS:= -o media=A4 -o fit-to-page -o sides=two-sided-short-edge -o landscape
LANG0      := Lang=0\\relax
LANG1      := Lang=1\\relax
# >>>
#
# Implicit rules (including ../bz/Mtargets.implicit)# <<<

include ../bz/Mtargets.implicit

%.tex : %.m
	octave -q $< > $@

$(WWWDIR)/%.pdf : %.pdf
	rsync -auv  $< $@

# End of implicit rules# >>>

default : x

# include Mtargets.rip-off-compute, Mtargets.last-edit# <<<
U = QDirty
RIP_FROM=*.tex
include ../bz/Mtargets.rip-off-compute # R, Octave, Ampl, Lingo rip-off
include ../bz/Mtargets.last-edit       # defines the LAST-targets
FILE        := $(basename $(LAST))
# >>>

# Rules # <<<

all:
	@echo "# To make all formelblad, issue:"
	@echo '  for i in formelblad-*.tex; do touch $i; make  www; done'

e:  e-last
ec:ec-last
et:et-last
v:  v-last
p:   $(FILE).lpr

x  : $(FILE).pdf   # and squeze (def'd in Mtargets.implicit)
xr :  x             $(FILE).pdfsq    $(WWWDIR)/$(FILE).pdf
xr2: $(FILE)-x2.pdf $(FILE)-x2.pdfsq $(WWWDIR)/$(FILE)-x2.pdf
xr4: $(FILE)-x4.pdf $(FILE)-x4.pdfsq $(WWWDIR)/$(FILE)-x4.pdf

# Special rules

tables: $(TEXTABLES)

www: xr xr2 xr4
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

clean: TeXclean
	rm -f *.pdf *.bak *.ps foo* *.gpg *~
