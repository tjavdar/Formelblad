# Makefle för formelblad CHANGES <<<

# 2019-02-17: New tabeller-st.tex supported by include's from ./tabeller-st/*.tex
# 2017-06-policy: Bi+Unilang divide, LANGctrl centralized -> Lang.h
# 2016-08-08: More include files/common targets and rules
# 2015-01-28: file to be done is the LAST-touched, unless explicitly defined
# 2011-03-11: No more intermediate dvi>>>

1st: t

# Mtargets includes: lang, implicit, rip, last + Var-defs: <<<
U = QDirty
RIP_FROM=*.tex
LAST_POOL=*.tex
SIMPLE := "Just define to use simple %.tex -> %.pdf-rules in Mtargets.implicit"

include ../bz/Mtargets.lang
include ../bz/Mtargets.implicit
include ../bz/Mtargets.rip-off-compute
include ../bz/Mtargets.last-edit

FILE          := $(basename $(LAST))
FILEx3        := $(FILE).pdf $(FILE)-x2.pdf $(FILE)-x4.pdf
ALLMATTEDIR   := ../allmatte
WWWDIR        := ../allmatte/formelblad
 
LANGIPUT    := '^.*input Lang.h'
isBILANG    := $(shell grep -l $(LANGIPUT) $(FILE).tex)
MATCH_BI    := $(shell grep -l $(LANGIPUT) *.tex)
MATCH_UNI   := $(shell grep -L $(LANGIPUT) *.tex)
MATCH_BI    := $(MATCH_BI:.tex=.pdf)
MATCH_UNI   := $(MATCH_UNI:.tex=.pdf)
TARG_SV     := $(addprefix $(WWWDIR)/sv/,$(MATCH_BI))
TARG_EN     := $(addprefix $(WWWDIR)/en/,$(MATCH_BI))
TARG_UNI    := $(addprefix $(WWWDIR)/,$(MATCH_UNI))
# >>>

# Rules, some implicit # <<<

# The cornerstone implicit rule:

t: $(FILE).pdf   # (default)

$(WWWDIR)/%.pdf $(WWWDIR)/en/%.pdf $(WWWDIR)/sv/%.pdf : %.tex
	# Scanning: $@
	if [ -n "$(findstring /sv/,$@)" ]; then make -s clean sv; fi
	if [ -n "$(findstring /en/,$@)" ]; then make -s clean en; fi
	make -sB FILE=$(basename $<) xsq 2>/dev/null
	rsync -auv \
	  $(basename $<).pdf \
	  $(basename $<)-x2.pdf \
	  $(basename $<)-x4.pdf \
	  $(dir $@)
	ls -ohl  $(dir $@)$(basename $<)*pdf

en: Lang.h # Global switch LANG to en
	@$(LANG_EN) $<  # def'd in bz/Mtargets.lang
sv: Lang.h # Global switch LANG to sv
	@$(LANG_SV) $<  # def'd in bz/Mtargets.lang
sl: Lang.h # Global *swap* LANG
	@$(LANG_SWAP) $< # def'd in bz/Mtargets.lang

e:  e-last #
v:  v-last #
p:  $(FILE).lpr #

x2:  $(FILE)-x2.pdf #
p2:  $(FILE)-x2.lpr #
x4:  $(FILE)-x4.pdf #
p4:  $(FILE)-x4.lpr #

xsq: $(FILEx3)
	for i in $(FILEx3); do pdf-squeeze.sh  $$i; done

# Special rules

www: # Exports only LAST modified (sv+en(if bi-lang))*(x1+x2+x4)
	@if [ -n "$(isBILANG)" ]; then \
	  make -s $(WWWDIR)/en/$(FILE).pdf; \
	  make -s $(WWWDIR)/sv/$(FILE).pdf; \
	else \
	  make -s $(WWWDIR)/$(FILE).pdf; \
	fi
	@echo "  make -C $(ALLMATTEDIR) www   # To pub sharp"; echo

www-all: $(TARG_UNI) $(TARG_SV) $(TARG_EN) #

ls-lang:  # List distribution by languages
	@echo ">> Sv+En: $(MATCH_BI:.pdf=)"
	@echo ">> Uni-l: $(MATCH_UNI:.pdf=)"
ls-targ:  # List targets (long paths)
	@echo ">> Unilang targets:"; for i in $(TARG_UNI);do echo $$i; done
	@echo ">> Sv-lang targets:"; for i in $(TARG_SV) ;do echo $$i; done
	@echo ">> En-lang targets:"; for i in $(TARG_EN) ;do echo $$i; done


help lhelp: #
	@echo;echo "Targets of interest:";echo
	@grep '^[A-Za-z0-9].*:.*#' Makefile
	@echo;echo "Policies:";echo
	# LAST touched formelblad is made by default: $(LAST)
	# From 2017-06: LANGctrl is centralized -> Lang.h
	#               bi-lingual f-blads \include-s Lang.h
	#               www: exports all variants of LAST (see target)
	#               www-all: exports all needing remake (may have 2 be repeated (bug/latexmk?))
	@echo

cl: clean

clean: TeXclean
	rm -f *.pdf  *~
