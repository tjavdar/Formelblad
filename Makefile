# Makefle för formelblad (started 2011-03-11)

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
# >>>

# Core rules # <<<

t: $(FILE).pdf   # (default)

e:  e-last # (Also et: in terminal)
v:  v-last #
p:  $(FILE).lpr # (Also: x2, p2,x4,p4)

x2:  $(FILE)-x2.pdf
p2:  $(FILE)-x2.lpr

en: Lang.h
	@$(LANG_EN) $<  # def'd in bz/Mtargets.lang
sv: Lang.h
	@$(LANG_SV) $<  # def'd in bz/Mtargets.lang
sl: Lang.h # Global *swap* LANG (Also: sv|en)
	@$(LANG_SWAP) $< # def'd in bz/Mtargets.lang
# >>>

# www-publishing Vars & Rules: www www-all ls-{targ,lang} <<<
FILES12        := $(FILE).pdf $(FILE)-x2.pdf
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

ls-lang:  # List distribution by languages
	@echo "# >> Sv+En-formeblad: $(MATCH_BI:.pdf=)" | sed "s/formelblad-//g"
	@echo "# >> Uni-l-formeblad: $(MATCH_UNI:.pdf=)" | sed "s/formelblad-//g"
ls-targ:  # List targets (long paths)
	@echo ">> Unilang targets:"; for i in $(TARG_UNI);do echo $$i; done
	@echo ">> Swedish targets:"; for i in $(TARG_SV) ;do echo $$i; done
	@echo ">> English targets:"; for i in $(TARG_EN) ;do echo $$i; done

xsq: $(FILES12)
	@for i in $(FILES12); do pdf-squeeze.sh $$i; done

$(WWWDIR)/en/%.pdf : %.tex en
	# >> En target: $@
	@make -sB FILE=$(basename $<) xsq 2>/dev/null
	rsync -au $(FILES12) $(dir $@)
$(WWWDIR)/sv/%.pdf : %.tex sv
	# >> Sv target: $@
	@make -sB FILE=$(basename $<) xsq 2>/dev/null
	rsync -au $(FILES12) $(dir $@)
$(WWWDIR)/%.pdf: %.tex
	# >> Unilang target: $@
	@make -sB FILE=$(basename $<) xsq 2>/dev/null
	rsync -au $(FILES12) $(dir $@)

ifeq ("$(isBILANG)","")
www: $(WWWDIR)/$(FILE).pdf #
	@echo -e "\n# >> Pub sharp:\n\t\tmake -C $(ALLMATTEDIR) www\n"
else
www: $(WWWDIR)/en/$(FILE).pdf $(WWWDIR)/sv/$(FILE).pdf
	@echo -e "\n# >> Pub sharp:  make -C $(ALLMATTEDIR) www\n"
endif

www-all: $(TARG_UNI) $(TARG_SV) $(TARG_EN) #
# >>>

# stat-help-clean rules:<<<
c stat: ls-lang last #

help lhelp: #
	@echo;echo "Targets of interest:";echo
	@grep '^[A-Za-z0-9].*:.*#' Makefile
	@echo

cl clean: TeXclean #
	rm -f *.pdf  *~
# >>>
