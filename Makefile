# Makefle för formelblad
# 2016-08-08: More include files/common targets and rules
# 2015-01-28: file to be done is the LAST-touched, unless explicitly defined
# 2011-03-11: No more intermediate dvi

# Övriga Makefile-vars # <<<
ALLMATTEDIR   := ../allmatte
WWWDIR        := ../allmatte/formelblad
BNAME         := formelblad
PS2PDF        := ps2pdfwr -dCompatibilityLevel=1.5 -sPAPERSIZE=a4
PDFNUP        := pdfnup --frame true --a4paper
x2_LPOPTIONS:= -o media=A4 -o fit-to-page -o sides=two-sided-short-edge -o landscape
# >>>
#
# Implicit rules (including ../bz/Mtargets.implicit)# <<<

include ../bz/Mtargets.lang
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
LAST_POOL=*.tex
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

www-en:
	make WWWDIR=$(WWWDIR)/en en www
www-sv:
	make WWWDIR=$(WWWDIR)/sv sv www
www-en+sv: www-en www-sv
www-sv+en: www-sv www-en

www: xr xr2 xr4
	@echo; echo Created and moved:
	@ls -oh $(WWWDIR)/$(FILE)*pdf
	@echo; echo Consider to:
	@echo; echo "        pushd $(ALLMATTEDIR); make  www; popd"; echo

en: $(FILE).tex
	@$(LANG_EN)
sv: $(FILE).tex
	@$(LANG_SV)
sl: $(FILE).tex
	@$(LANG_SWAP)

help lhelp:
	# Usage:
	#
	# Last touched formelblad is made by default
	# Put AMNE = an|la|tr|fv|mv for corresponding formelblad
	#
	# make ls|en|sv # for lang swap, en or sv
	# make || make www[-en|sv|sv+en|en+sv]

cl: clean

clean: TeXclean
	rm -f *.pdf *.bak *.ps foo* *.gpg *~
