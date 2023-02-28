##########################################################################
##         #   The Coq Proof Assistant / The Coq Development Team       ##
##  v      #         Copyright INRIA, CNRS and contributors             ##
## <O___,, # (see version control and CREDITS file for authors & dates) ##
##   \VV/  ###############################################################
##    //   #    This file is distributed under the terms of the         ##
##         #     GNU Lesser General Public License Version 2.1          ##
##         #     (see LICENSE file for the text of the license)         ##
##########################################################################
## GNUMakefile for Coq 8.15.2

# For debugging purposes (must stay here, don't move below)
INITIAL_VARS := $(.VARIABLES)
# To implement recursion we save the name of the main Makefile
SELF := $(lastword $(MAKEFILE_LIST))
PARENT := $(firstword $(MAKEFILE_LIST))

# This file is generated by coq_makefile and contains many variable
# definitions, like the list of .v files or the path to Coq
include Makefile.conf

# Put in place old names
VFILES            := $(COQMF_VFILES)
MLIFILES          := $(COQMF_MLIFILES)
MLFILES           := $(COQMF_MLFILES)
MLGFILES          := $(COQMF_MLGFILES)
MLPACKFILES       := $(COQMF_MLPACKFILES)
MLLIBFILES        := $(COQMF_MLLIBFILES)
CMDLINE_VFILES    := $(COQMF_CMDLINE_VFILES)
INSTALLCOQDOCROOT := $(COQMF_INSTALLCOQDOCROOT)
OTHERFLAGS        := $(COQMF_OTHERFLAGS)
COQCORE_SRC_SUBDIRS := $(COQMF_COQ_SRC_SUBDIRS)
OCAMLLIBS         := $(COQMF_OCAMLLIBS)
SRC_SUBDIRS       := $(COQMF_SRC_SUBDIRS)
COQLIBS           := $(COQMF_COQLIBS)
COQLIBS_NOML      := $(COQMF_COQLIBS_NOML)
CMDLINE_COQLIBS   := $(COQMF_CMDLINE_COQLIBS)
COQLIB            := $(COQMF_COQLIB)
COQCORELIB        := $(COQMF_COQCORELIB)
DOCDIR            := $(COQMF_DOCDIR)
OCAMLFIND         := $(COQMF_OCAMLFIND)
CAMLFLAGS         := $(COQMF_CAMLFLAGS)
HASNATDYNLINK     := $(COQMF_HASNATDYNLINK)
OCAMLWARN         := $(COQMF_WARN)

Makefile.conf: _CoqProject
	coq_makefile -f _CoqProject AltAuto.v AltAutoTest.v Auto.v AutoTest.v Basics.v BasicsTest.v Bib.v BibTest.v Extraction.v ExtractionTest.v Imp.v ImpCEvalFun.v ImpCEvalFunTest.v ImpParser.v ImpParserTest.v ImpTest.v IndPrinciples.v IndPrinciplesTest.v IndProp.v IndPropTest.v Induction.v InductionTest.v Lists.v ListsTest.v Logic.v LogicTest.v Maps.v MapsTest.v Poly.v PolyTest.v Postscript.v PostscriptTest.v Preface.v PrefaceTest.v ProofObjects.v ProofObjectsTest.v Rel.v RelTest.v Tactics.v TacticsTest.v -o Makefile

# This file can be created by the user to hook into double colon rules or
# add any other Makefile code he may need
-include Makefile.local

# Parameters ##################################################################
#
# Parameters are make variable assignments.
# They can be passed to (each call to) make on the command line.
# They can also be put in Makefile.local once and for all.
# For retro-compatibility reasons they can be put in the _CoqProject, but this
# practice is discouraged since _CoqProject better not contain make specific
# code (be nice to user interfaces).

# set KEEP_ERROR to prevent make from deleting files produced by failing rules.
# For instance if coqc creates a .vo but then fails to native compile,
# the .vo will be deleted unless KEEP_ERROR is nonempty.
# May confuse make so use only for debugging.
KEEP_ERROR?=
ifneq (,$(KEEP_ERROR))
.DELETE_ON_ERROR:
endif

# Print shell commands (set to non empty)
VERBOSE ?=

# Time the Coq process (set to non empty), and how (see default value)
TIMED?=
TIMECMD?=
# Use command time on linux, gtime on Mac OS
TIMEFMT?="$@ (real: %e, user: %U, sys: %S, mem: %M ko)"
ifneq (,$(TIMED))
ifeq (0,$(shell command time -f "" true >/dev/null 2>/dev/null; echo $$?))
STDTIME?=command time -f $(TIMEFMT)
else
ifeq (0,$(shell gtime -f "" true >/dev/null 2>/dev/null; echo $$?))
STDTIME?=gtime -f $(TIMEFMT)
else
STDTIME?=command time
endif
endif
else
STDTIME?=command time -f $(TIMEFMT)
endif

COQBIN?=
ifneq (,$(COQBIN))
# add an ending /
COQBIN:=$(COQBIN)/
endif

# Coq binaries
COQC     ?= "$(COQBIN)coqc"
COQTOP   ?= "$(COQBIN)coqtop"
COQCHK   ?= "$(COQBIN)coqchk"
COQNATIVE ?= "$(COQBIN)coqnative"
COQDEP   ?= "$(COQBIN)coqdep"
COQDOC   ?= "$(COQBIN)coqdoc"
COQPP    ?= "$(COQBIN)coqpp"
COQMKFILE ?= "$(COQBIN)coq_makefile"
OCAMLLIBDEP ?= "$(COQBIN)ocamllibdep"

# Timing scripts
COQMAKE_ONE_TIME_FILE ?= "$(COQCORELIB)/tools/make-one-time-file.py"
COQMAKE_BOTH_TIME_FILES ?= "$(COQCORELIB)/tools/make-both-time-files.py"
COQMAKE_BOTH_SINGLE_TIMING_FILES ?= "$(COQCORELIB)/tools/make-both-single-timing-files.py"
BEFORE ?=
AFTER ?=

# FIXME this should be generated by Coq (modules already linked by Coq)
CAMLDONTLINK=str,unix,dynlink,threads,zarith

# OCaml binaries
CAMLC       ?= "$(OCAMLFIND)" ocamlc   -c
CAMLOPTC    ?= "$(OCAMLFIND)" opt      -c
CAMLLINK    ?= "$(OCAMLFIND)" ocamlc   -linkpkg -dontlink $(CAMLDONTLINK)
CAMLOPTLINK ?= "$(OCAMLFIND)" opt      -linkpkg -dontlink $(CAMLDONTLINK)
CAMLDOC     ?= "$(OCAMLFIND)" ocamldoc
CAMLDEP     ?= "$(OCAMLFIND)" ocamldep -slash -ml-synonym .mlpack

# DESTDIR is prepended to all installation paths
DESTDIR ?=

# Debug builds, typically -g to OCaml, -debug to Coq.
CAMLDEBUG ?=
COQDEBUG ?=

# Extra packages to be linked in (as in findlib -package)
CAMLPKGS ?=

# Option for making timing files
TIMING?=
# Option for changing sorting of timing output file
TIMING_SORT_BY ?= auto
# Option for changing the fuzz parameter on the output file
TIMING_FUZZ ?= 0
# Option for changing whether to use real or user time for timing tables
TIMING_REAL?=
# Option for including the memory column(s)
TIMING_INCLUDE_MEM?=
# Option for sorting by the memory column
TIMING_SORT_BY_MEM?=
# Output file names for timed builds
TIME_OF_BUILD_FILE               ?= time-of-build.log
TIME_OF_BUILD_BEFORE_FILE        ?= time-of-build-before.log
TIME_OF_BUILD_AFTER_FILE         ?= time-of-build-after.log
TIME_OF_PRETTY_BUILD_FILE        ?= time-of-build-pretty.log
TIME_OF_PRETTY_BOTH_BUILD_FILE   ?= time-of-build-both.log
TIME_OF_PRETTY_BUILD_EXTRA_FILES ?= - # also output to the command line

TGTS ?=

# Retro compatibility (DESTDIR is standard on Unix, DSTROOT is not)
ifdef DSTROOT
DESTDIR := $(DSTROOT)
endif

# Substitution of the path by appending $(DESTDIR) if needed.
# The variable $(COQMF_WINDRIVE) can be needed for Cygwin environments.
windrive_path = $(if $(COQMF_WINDRIVE),$(subst $(COQMF_WINDRIVE),/,$(1)),$(1))
destination_path = $(if $(DESTDIR),$(DESTDIR)/$(call windrive_path,$(1)),$(1))

# Installation paths of libraries and documentation.
COQLIBINSTALL ?= $(call destination_path,$(COQLIB)/user-contrib)
COQDOCINSTALL ?= $(call destination_path,$(DOCDIR)/coq/user-contrib)
COQTOPINSTALL ?= $(call destination_path,$(COQLIB)/toploop) # FIXME: Unused variable?

########## End of parameters ##################################################
# What follows may be relevant to you only if you need to
# extend this Makefile.  If so, look for 'Extension point' here and
# put in Makefile.local double colon rules accordingly.
# E.g. to perform some work after the all target completes you can write
#
# post-all::
# 	echo "All done!"
#
# in Makefile.local
#
###############################################################################




# Flags #######################################################################
#
# We define a bunch of variables combining the parameters.
# To add additional flags to coq, coqchk or coqdoc, set the
# {COQ,COQCHK,COQDOC}EXTRAFLAGS variable to whatever you want to add.
# To overwrite the default choice and set your own flags entirely, set the
# {COQ,COQCHK,COQDOC}FLAGS variable.

SHOW := $(if $(VERBOSE),@true "",@echo "")
HIDE := $(if $(VERBOSE),,@)

TIMER=$(if $(TIMED), $(STDTIME), $(TIMECMD))

OPT?=

# The DYNOBJ and DYNLIB variables are used by "coqdep -dyndep var" in .v.d
ifeq '$(OPT)' '-byte'
USEBYTE:=true
DYNOBJ:=.cma
DYNLIB:=.cma
else
USEBYTE:=
DYNOBJ:=.cmxs
DYNLIB:=.cmxs
endif

# these variables are meant to be overridden if you want to add *extra* flags
COQEXTRAFLAGS?=
COQCHKEXTRAFLAGS?=
COQDOCEXTRAFLAGS?=

# Find the last argument of the form "-native-compiler FLAG"
COQUSERNATIVEFLAG:=$(strip \
$(subst -native-compiler-,,\
$(lastword \
$(filter -native-compiler-%,\
$(subst -native-compiler ,-native-compiler-,\
$(strip $(COQEXTRAFLAGS)))))))

COQFILTEREDEXTRAFLAGS:=$(strip \
$(filter-out -native-compiler-%,\
$(subst -native-compiler ,-native-compiler-,\
$(strip $(COQEXTRAFLAGS)))))

COQACTUALNATIVEFLAG:=$(lastword $(COQMF_COQ_NATIVE_COMPILER_DEFAULT) $(COQMF_COQPROJECTNATIVEFLAG) $(COQUSERNATIVEFLAG))

ifeq '$(COQACTUALNATIVEFLAG)' 'yes'
  COQNATIVEFLAG="-w" "-deprecated-native-compiler-option" "-native-compiler" "ondemand"
  COQDONATIVE="yes"
else
ifeq '$(COQACTUALNATIVEFLAG)' 'ondemand'
  COQNATIVEFLAG="-w" "-deprecated-native-compiler-option" "-native-compiler" "ondemand"
  COQDONATIVE="no"
else
  COQNATIVEFLAG="-w" "-deprecated-native-compiler-option" "-native-compiler" "no"
  COQDONATIVE="no"
endif
endif

# these flags do NOT contain the libraries, to make them easier to overwrite
COQFLAGS?=-q $(OTHERFLAGS) $(COQFILTEREDEXTRAFLAGS) $(COQNATIVEFLAG)
COQCHKFLAGS?=-silent -o $(COQCHKEXTRAFLAGS)
COQDOCFLAGS?=-interpolate -utf8 $(COQDOCEXTRAFLAGS)

COQDOCLIBS?=$(COQLIBS_NOML)

# The version of Coq being run and the version of coq_makefile that
# generated this makefile
COQ_VERSION:=$(shell $(COQC) --print-version | cut -d " " -f 1)
COQMAKEFILE_VERSION:=8.15.2

# COQ_SRC_SUBDIRS is for user-overriding, usually to add
# `user-contrib/Foo` to the includes, we keep COQCORE_SRC_SUBDIRS for
# Coq's own core libraries, which should be replaced by ocamlfind
# options at some point.
COQ_SRC_SUBDIRS?=
COQSRCLIBS?= $(foreach d,$(COQCORE_SRC_SUBDIRS), -I "$(COQCORELIB)/$(d)") $(foreach d,$(COQ_SRC_SUBDIRS), -I "$(COQLIB)/$(d)")

CAMLFLAGS+=$(OCAMLLIBS) $(COQSRCLIBS)
# ocamldoc fails with unknown argument otherwise
CAMLDOCFLAGS:=$(filter-out -annot, $(filter-out -bin-annot, $(CAMLFLAGS)))
CAMLFLAGS+=$(OCAMLWARN)

ifneq (,$(TIMING))
TIMING_ARG=-time
ifeq (after,$(TIMING))
TIMING_EXT=after-timing
else
ifeq (before,$(TIMING))
TIMING_EXT=before-timing
else
TIMING_EXT=timing
endif
endif
else
TIMING_ARG=
endif

# Files #######################################################################
#
# We here define a bunch of variables about the files being part of the
# Coq project in order to ease the writing of build target and build rules

VDFILE := .Makefile.d

ALLSRCFILES := \
	$(MLGFILES) \
	$(MLFILES) \
	$(MLPACKFILES) \
	$(MLLIBFILES) \
	$(MLIFILES)

# helpers
vo_to_obj = $(addsuffix .o,\
  $(filter-out Warning: Error:,\
  $(shell $(COQTOP) -q -noinit -batch -quiet -print-mod-uid $(1))))
strip_dotslash = $(patsubst ./%,%,$(1))

# without this we get undefined variables in the expansion for the
# targets of the [deprecated,use-mllib-or-mlpack] rule
with_undef = $(if $(filter-out undefined, $(origin $(1))),$($(1)))

VO = vo
VOS = vos

VOFILES = $(VFILES:.v=.$(VO))
GLOBFILES = $(VFILES:.v=.glob)
HTMLFILES = $(VFILES:.v=.html)
GHTMLFILES = $(VFILES:.v=.g.html)
BEAUTYFILES = $(addsuffix .beautified,$(VFILES))
TEXFILES = $(VFILES:.v=.tex)
GTEXFILES = $(VFILES:.v=.g.tex)
CMOFILES = \
	$(MLGFILES:.mlg=.cmo) \
	$(MLFILES:.ml=.cmo) \
	$(MLPACKFILES:.mlpack=.cmo)
CMXFILES = $(CMOFILES:.cmo=.cmx)
OFILES = $(CMXFILES:.cmx=.o)
CMAFILES = $(MLLIBFILES:.mllib=.cma) $(MLPACKFILES:.mlpack=.cma)
CMXAFILES = $(CMAFILES:.cma=.cmxa)
CMIFILES = \
	$(CMOFILES:.cmo=.cmi) \
	$(MLIFILES:.mli=.cmi)
# the /if/ is because old _CoqProject did not list a .ml(pack|lib) but just
# a .mlg file
CMXSFILES = \
	$(MLPACKFILES:.mlpack=.cmxs) \
	$(CMXAFILES:.cmxa=.cmxs) \
	$(if $(MLPACKFILES)$(CMXAFILES),,\
		$(MLGFILES:.mlg=.cmxs) $(MLFILES:.ml=.cmxs))

# files that are packed into a plugin (no extension)
PACKEDFILES = \
	$(call strip_dotslash, \
	  $(foreach lib, \
	    $(call strip_dotslash, \
	       $(MLPACKFILES:.mlpack=_MLPACK_DEPENDENCIES)),$(call with_undef,$(lib))))
# files that are archived into a .cma (mllib)
LIBEDFILES = \
	$(call strip_dotslash, \
	  $(foreach lib, \
	    $(call strip_dotslash, \
	       $(MLLIBFILES:.mllib=_MLLIB_DEPENDENCIES)),$(call with_undef,$(lib))))
CMIFILESTOINSTALL = $(filter-out $(addsuffix .cmi,$(PACKEDFILES)),$(CMIFILES))
CMOFILESTOINSTALL = $(filter-out $(addsuffix .cmo,$(PACKEDFILES)),$(CMOFILES))
OBJFILES = $(call vo_to_obj,$(VOFILES))
ALLNATIVEFILES = \
	$(OBJFILES:.o=.cmi) \
	$(OBJFILES:.o=.cmx) \
	$(OBJFILES:.o=.cmxs)
# trick: wildcard filters out non-existing files, so that `install` doesn't show
# warnings and `clean` doesn't pass to rm a list of files that is too long for
# the shell.
NATIVEFILES = $(wildcard $(ALLNATIVEFILES))
FILESTOINSTALL = \
	$(VOFILES) \
	$(VFILES) \
	$(GLOBFILES) \
	$(NATIVEFILES) \
	$(CMIFILESTOINSTALL)
BYTEFILESTOINSTALL = \
	$(CMOFILESTOINSTALL) \
	$(CMAFILES)
ifeq '$(HASNATDYNLINK)' 'true'
DO_NATDYNLINK = yes
FILESTOINSTALL += $(CMXSFILES) $(CMXAFILES) $(CMOFILESTOINSTALL:.cmo=.cmx)
else
DO_NATDYNLINK =
endif

ALLDFILES = $(addsuffix .d,$(ALLSRCFILES)) $(VDFILE)

# Compilation targets #########################################################

all:
	$(HIDE)$(MAKE) --no-print-directory -f "$(SELF)" pre-all
	$(HIDE)$(MAKE) --no-print-directory -f "$(SELF)" real-all
	$(HIDE)$(MAKE) --no-print-directory -f "$(SELF)" post-all
.PHONY: all

all.timing.diff:
	$(HIDE)$(MAKE) --no-print-directory -f "$(SELF)" pre-all
	$(HIDE)$(MAKE) --no-print-directory -f "$(SELF)" real-all.timing.diff TIME_OF_PRETTY_BUILD_EXTRA_FILES=""
	$(HIDE)$(MAKE) --no-print-directory -f "$(SELF)" post-all
.PHONY: all.timing.diff

ifeq (0,$(TIMING_REAL))
TIMING_REAL_ARG :=
TIMING_USER_ARG := --user
else
ifeq (1,$(TIMING_REAL))
TIMING_REAL_ARG := --real
TIMING_USER_ARG :=
else
TIMING_REAL_ARG :=
TIMING_USER_ARG :=
endif
endif

ifeq (0,$(TIMING_INCLUDE_MEM))
TIMING_INCLUDE_MEM_ARG := --no-include-mem
else
TIMING_INCLUDE_MEM_ARG :=
endif

ifeq (1,$(TIMING_SORT_BY_MEM))
TIMING_SORT_BY_MEM_ARG := --sort-by-mem
else
TIMING_SORT_BY_MEM_ARG :=
endif

make-pretty-timed-before:: TIME_OF_BUILD_FILE=$(TIME_OF_BUILD_BEFORE_FILE)
make-pretty-timed-after:: TIME_OF_BUILD_FILE=$(TIME_OF_BUILD_AFTER_FILE)
make-pretty-timed make-pretty-timed-before make-pretty-timed-after::
	$(HIDE)rm -f pretty-timed-success.ok
	$(HIDE)($(MAKE) --no-print-directory -f "$(PARENT)" $(TGTS) TIMED=1 2>&1 && touch pretty-timed-success.ok) | tee -a $(TIME_OF_BUILD_FILE)
	$(HIDE)rm pretty-timed-success.ok # must not be -f; must fail if the touch failed
print-pretty-timed::
	$(HIDE)$(COQMAKE_ONE_TIME_FILE) $(TIMING_INCLUDE_MEM_ARG) $(TIMING_SORT_BY_MEM_ARG) $(TIMING_REAL_ARG) $(TIME_OF_BUILD_FILE) $(TIME_OF_PRETTY_BUILD_FILE) $(TIME_OF_PRETTY_BUILD_EXTRA_FILES)
print-pretty-timed-diff::
	$(HIDE)$(COQMAKE_BOTH_TIME_FILES) --sort-by=$(TIMING_SORT_BY) $(TIMING_INCLUDE_MEM_ARG) $(TIMING_SORT_BY_MEM_ARG) $(TIMING_REAL_ARG) $(TIME_OF_BUILD_AFTER_FILE) $(TIME_OF_BUILD_BEFORE_FILE) $(TIME_OF_PRETTY_BOTH_BUILD_FILE) $(TIME_OF_PRETTY_BUILD_EXTRA_FILES)
ifeq (,$(BEFORE))
print-pretty-single-time-diff::
	@echo 'Error: Usage: $(MAKE) print-pretty-single-time-diff AFTER=path/to/file.v.after-timing BEFORE=path/to/file.v.before-timing'
	$(HIDE)false
else
ifeq (,$(AFTER))
print-pretty-single-time-diff::
	@echo 'Error: Usage: $(MAKE) print-pretty-single-time-diff AFTER=path/to/file.v.after-timing BEFORE=path/to/file.v.before-timing'
	$(HIDE)false
else
print-pretty-single-time-diff::
	$(HIDE)$(COQMAKE_BOTH_SINGLE_TIMING_FILES) --fuzz=$(TIMING_FUZZ) --sort-by=$(TIMING_SORT_BY) $(TIMING_USER_ARG) $(AFTER) $(BEFORE) $(TIME_OF_PRETTY_BUILD_FILE) $(TIME_OF_PRETTY_BUILD_EXTRA_FILES)
endif
endif
pretty-timed:
	$(HIDE)$(MAKE) --no-print-directory -f "$(PARENT)" make-pretty-timed
	$(HIDE)$(MAKE) --no-print-directory -f "$(SELF)" print-pretty-timed
.PHONY: pretty-timed make-pretty-timed make-pretty-timed-before make-pretty-timed-after print-pretty-timed print-pretty-timed-diff print-pretty-single-time-diff

# Extension points for actions to be performed before/after the all target
pre-all::
	@# Extension point
	$(HIDE)if [ "$(COQMAKEFILE_VERSION)" != "$(COQ_VERSION)" ]; then\
	  echo "W: This Makefile was generated by Coq $(COQMAKEFILE_VERSION)";\
	  echo "W: while the current Coq version is $(COQ_VERSION)";\
	fi
.PHONY: pre-all

post-all::
	@# Extension point
.PHONY: post-all

real-all: $(VOFILES) $(if $(USEBYTE),bytefiles,optfiles)
.PHONY: real-all

real-all.timing.diff: $(VOFILES:.vo=.v.timing.diff)
.PHONY: real-all.timing.diff

bytefiles: $(CMOFILES) $(CMAFILES)
.PHONY: bytefiles

optfiles: $(if $(DO_NATDYNLINK),$(CMXSFILES))
.PHONY: optfiles

# FIXME, see Ralf's bugreport
# quick is deprecated, now renamed vio
vio: $(VOFILES:.vo=.vio)
.PHONY: vio
quick: vio
	$(warning "'make quick' is deprecated, use 'make vio' or consider using 'vos' files")
.PHONY: quick

vio2vo:
	$(TIMER) $(COQC) $(COQDEBUG) $(COQFLAGS) $(COQLIBS) \
		-schedule-vio2vo $(J) $(VOFILES:%.vo=%.vio)
.PHONY: vio2vo

# quick2vo is undocumented
quick2vo:
	$(HIDE)make -j $(J) vio
	$(HIDE)VIOFILES=$$(for vofile in $(VOFILES); do \
	  viofile="$$(echo "$$vofile" | sed "s/\.vo$$/.vio/")"; \
	  if [ "$$vofile" -ot "$$viofile" -o ! -e "$$vofile" ]; then printf "$$viofile "; fi; \
	done); \
	echo "VIO2VO: $$VIOFILES"; \
	if [ -n "$$VIOFILES" ]; then \
	  $(TIMER) $(COQC) $(COQDEBUG) $(COQFLAGS) $(COQLIBS) -schedule-vio2vo $(J) $$VIOFILES; \
	fi
.PHONY: quick2vo

checkproofs:
	$(TIMER) $(COQC) $(COQDEBUG) $(COQFLAGS) $(COQLIBS) \
		-schedule-vio-checking $(J) $(VOFILES:%.vo=%.vio)
.PHONY: checkproofs

vos: $(VOFILES:%.vo=%.vos)
.PHONY: vos

vok: $(VOFILES:%.vo=%.vok)
.PHONY: vok

validate: $(VOFILES)
	$(TIMER) $(COQCHK) $(COQCHKFLAGS) $(COQLIBS_NOML) $^
.PHONY: validate

only: $(TGTS)
.PHONY: only

# Documentation targets #######################################################

html: $(GLOBFILES) $(VFILES)
	$(SHOW)'COQDOC -d html $(GAL)'
	$(HIDE)mkdir -p html
	$(HIDE)$(COQDOC) \
		-toc $(COQDOCFLAGS) -html $(GAL) $(COQDOCLIBS) -d html $(VFILES)

mlihtml: $(MLIFILES:.mli=.cmi)
	$(SHOW)'CAMLDOC -d $@'
	$(HIDE)mkdir $@ || rm -rf $@/*
	$(HIDE)$(CAMLDOC) -html \
		-d $@ -m A $(CAMLDEBUG) $(CAMLDOCFLAGS) $(MLIFILES)

all-mli.tex: $(MLIFILES:.mli=.cmi)
	$(SHOW)'CAMLDOC -latex $@'
	$(HIDE)$(CAMLDOC) -latex \
		-o $@ -m A $(CAMLDEBUG) $(CAMLDOCFLAGS) $(MLIFILES)

all.ps: $(VFILES)
	$(SHOW)'COQDOC -ps $(GAL)'
	$(HIDE)$(COQDOC) \
		-toc $(COQDOCFLAGS) -ps $(GAL) $(COQDOCLIBS) \
		-o $@ `$(COQDEP) -sort $(VFILES)`

all.pdf: $(VFILES)
	$(SHOW)'COQDOC -pdf $(GAL)'
	$(HIDE)$(COQDOC) \
		-toc $(COQDOCFLAGS) -pdf $(GAL) $(COQDOCLIBS) \
		-o $@ `$(COQDEP) -sort $(VFILES)`

# FIXME: not quite right, since the output name is different
gallinahtml: GAL=-g
gallinahtml: html

all-gal.ps: GAL=-g
all-gal.ps: all.ps

all-gal.pdf: GAL=-g
all-gal.pdf: all.pdf

# ?
beautify: $(BEAUTYFILES)
	for file in $^; do mv $${file%.beautified} $${file%beautified}old && mv $${file} $${file%.beautified}; done
	@echo 'Do not do "make clean" until you are sure that everything went well!'
	@echo 'If there were a problem, execute "for file in $$(find . -name \*.v.old -print); do mv $${file} $${file%.old}; done" in your shell/'
.PHONY: beautify

# Installation targets ########################################################
#
# There rules can be extended in Makefile.local
# Extensions can't assume when they run.

install:
	$(HIDE)code=0; for f in $(FILESTOINSTALL); do\
	 if ! [ -f "$$f" ]; then >&2 echo $$f does not exist; code=1; fi \
	done; exit $$code
	$(HIDE)for f in $(FILESTOINSTALL); do\
	 df="`$(COQMKFILE) -destination-of "$$f" $(COQLIBS)`";\
	 if [ "$$?" != "0" -o -z "$$df" ]; then\
	   echo SKIP "$$f" since it has no logical path;\
	 else\
	   install -d "$(COQLIBINSTALL)/$$df" &&\
	   install -m 0644 "$$f" "$(COQLIBINSTALL)/$$df" &&\
	   echo INSTALL "$$f" "$(COQLIBINSTALL)/$$df";\
	 fi;\
	done
	$(HIDE)$(MAKE) install-extra -f "$(SELF)"
install-extra::
	@# Extension point
.PHONY: install install-extra

install-byte:
	$(HIDE)for f in $(BYTEFILESTOINSTALL); do\
	 df="`$(COQMKFILE) -destination-of "$$f" $(COQLIBS)`";\
	 if [ "$$?" != "0" -o -z "$$df" ]; then\
	   echo SKIP "$$f" since it has no logical path;\
	 else\
	   install -d "$(COQLIBINSTALL)/$$df" &&\
	   install -m 0644 "$$f" "$(COQLIBINSTALL)/$$df" &&\
	   echo INSTALL "$$f" "$(COQLIBINSTALL)/$$df";\
	 fi;\
	done

install-doc:: html mlihtml
	@# Extension point
	$(HIDE)install -d "$(COQDOCINSTALL)/$(INSTALLCOQDOCROOT)/html"
	$(HIDE)for i in html/*; do \
	 dest="$(COQDOCINSTALL)/$(INSTALLCOQDOCROOT)/$$i";\
	 install -m 0644 "$$i" "$$dest";\
	 echo INSTALL "$$i" "$$dest";\
	done
	$(HIDE)install -d \
		"$(COQDOCINSTALL)/$(INSTALLCOQDOCROOT)/mlihtml"
	$(HIDE)for i in mlihtml/*; do \
	 dest="$(COQDOCINSTALL)/$(INSTALLCOQDOCROOT)/$$i";\
	 install -m 0644 "$$i" "$$dest";\
	 echo INSTALL "$$i" "$$dest";\
	done
.PHONY: install-doc

uninstall::
	@# Extension point
	$(HIDE)for f in $(FILESTOINSTALL); do \
	 df="`$(COQMKFILE) -destination-of "$$f" $(COQLIBS)`" &&\
	 instf="$(COQLIBINSTALL)/$$df/`basename $$f`" &&\
	 rm -f "$$instf" &&\
	 echo RM "$$instf" &&\
	 (rmdir "$(COQLIBINSTALL)/$$df/" 2>/dev/null || true); \
	done
.PHONY: uninstall

uninstall-doc::
	@# Extension point
	$(SHOW)'RM $(COQDOCINSTALL)/$(INSTALLCOQDOCROOT)/html'
	$(HIDE)rm -rf "$(COQDOCINSTALL)/$(INSTALLCOQDOCROOT)/html"
	$(SHOW)'RM $(COQDOCINSTALL)/$(INSTALLCOQDOCROOT)/mlihtml'
	$(HIDE)rm -rf "$(COQDOCINSTALL)/$(INSTALLCOQDOCROOT)/mlihtml"
	$(HIDE) rmdir "$(COQDOCINSTALL)/$(INSTALLCOQDOCROOT)/" || true
.PHONY: uninstall-doc

# Cleaning ####################################################################
#
# There rules can be extended in Makefile.local
# Extensions can't assume when they run.

clean::
	@# Extension point
	$(SHOW)'CLEAN'
	$(HIDE)rm -f $(CMOFILES)
	$(HIDE)rm -f $(CMIFILES)
	$(HIDE)rm -f $(CMAFILES)
	$(HIDE)rm -f $(CMOFILES:.cmo=.cmx)
	$(HIDE)rm -f $(CMXAFILES)
	$(HIDE)rm -f $(CMXSFILES)
	$(HIDE)rm -f $(CMOFILES:.cmo=.o)
	$(HIDE)rm -f $(CMXAFILES:.cmxa=.a)
	$(HIDE)rm -f $(MLGFILES:.mlg=.ml)
	$(HIDE)rm -f $(ALLDFILES)
	$(HIDE)rm -f $(NATIVEFILES)
	$(HIDE)find . -name .coq-native -type d -empty -delete
	$(HIDE)rm -f $(VOFILES)
	$(HIDE)rm -f $(VOFILES:.vo=.vio)
	$(HIDE)rm -f $(VOFILES:.vo=.vos)
	$(HIDE)rm -f $(VOFILES:.vo=.vok)
	$(HIDE)rm -f $(BEAUTYFILES) $(VFILES:=.old)
	$(HIDE)rm -f all.ps all-gal.ps all.pdf all-gal.pdf all.glob all-mli.tex
	$(HIDE)rm -f $(VFILES:.v=.glob)
	$(HIDE)rm -f $(VFILES:.v=.tex)
	$(HIDE)rm -f $(VFILES:.v=.g.tex)
	$(HIDE)rm -f pretty-timed-success.ok
	$(HIDE)rm -rf html mlihtml
.PHONY: clean

cleanall:: clean
	@# Extension point
	$(SHOW)'CLEAN *.aux *.timing'
	$(HIDE)rm -f $(foreach f,$(VFILES:.v=),$(dir $(f)).$(notdir $(f)).aux)
	$(HIDE)rm -f $(TIME_OF_BUILD_FILE) $(TIME_OF_BUILD_BEFORE_FILE) $(TIME_OF_BUILD_AFTER_FILE) $(TIME_OF_PRETTY_BUILD_FILE) $(TIME_OF_PRETTY_BOTH_BUILD_FILE)
	$(HIDE)rm -f $(VOFILES:.vo=.v.timing)
	$(HIDE)rm -f $(VOFILES:.vo=.v.before-timing)
	$(HIDE)rm -f $(VOFILES:.vo=.v.after-timing)
	$(HIDE)rm -f $(VOFILES:.vo=.v.timing.diff)
	$(HIDE)rm -f .lia.cache .nia.cache
.PHONY: cleanall

archclean::
	@# Extension point
	$(SHOW)'CLEAN *.cmx *.o'
	$(HIDE)rm -f $(NATIVEFILES)
	$(HIDE)rm -f $(CMOFILES:%.cmo=%.cmx)
.PHONY: archclean


# Compilation rules ###########################################################

$(MLIFILES:.mli=.cmi): %.cmi: %.mli
	$(SHOW)'CAMLC -c $<'
	$(HIDE)$(TIMER) $(CAMLC) $(CAMLDEBUG) $(CAMLFLAGS) $(CAMLPKGS) $<

$(MLGFILES:.mlg=.ml): %.ml: %.mlg
	$(SHOW)'COQPP $<'
	$(HIDE)$(COQPP) $<

# Stupid hack around a deficient syntax: we cannot concatenate two expansions
$(filter %.cmo, $(MLFILES:.ml=.cmo) $(MLGFILES:.mlg=.cmo)): %.cmo: %.ml
	$(SHOW)'CAMLC -c $<'
	$(HIDE)$(TIMER) $(CAMLC) $(CAMLDEBUG) $(CAMLFLAGS) $(CAMLPKGS) $<

# Same hack
$(filter %.cmx, $(MLFILES:.ml=.cmx) $(MLGFILES:.mlg=.cmx)): %.cmx: %.ml
	$(SHOW)'CAMLOPT -c $(FOR_PACK) $<'
	$(HIDE)$(TIMER) $(CAMLOPTC) $(CAMLDEBUG) $(CAMLFLAGS) $(CAMLPKGS) $(FOR_PACK) $<


$(MLLIBFILES:.mllib=.cmxs): %.cmxs: %.cmxa
	$(SHOW)'CAMLOPT -shared -o $@'
	$(HIDE)$(TIMER) $(CAMLOPTLINK) $(CAMLDEBUG) $(CAMLFLAGS) $(CAMLPKGS) \
		-linkall -shared -o $@ $<

$(MLLIBFILES:.mllib=.cma): %.cma: | %.mllib
	$(SHOW)'CAMLC -a -o $@'
	$(HIDE)$(TIMER) $(CAMLLINK) $(CAMLDEBUG) $(CAMLFLAGS) $(CAMLPKGS) -a -o $@ $^

$(MLLIBFILES:.mllib=.cmxa): %.cmxa: | %.mllib
	$(SHOW)'CAMLOPT -a -o $@'
	$(HIDE)$(TIMER) $(CAMLOPTLINK) $(CAMLDEBUG) $(CAMLFLAGS) -a -o $@ $^


$(MLPACKFILES:.mlpack=.cmxs): %.cmxs: %.cmxa
	$(SHOW)'CAMLOPT -shared -o $@'
	$(HIDE)$(TIMER) $(CAMLOPTLINK) $(CAMLDEBUG) $(CAMLFLAGS) $(CAMLPKGS) \
		-shared -linkall -o $@ $<

$(MLPACKFILES:.mlpack=.cmxa): %.cmxa: %.cmx
	$(SHOW)'CAMLOPT -a -o $@'
	$(HIDE)$(TIMER) $(CAMLOPTLINK) $(CAMLDEBUG) $(CAMLFLAGS) -a -o $@ $<

$(MLPACKFILES:.mlpack=.cma): %.cma: %.cmo | %.mlpack
	$(SHOW)'CAMLC -a -o $@'
	$(HIDE)$(TIMER) $(CAMLLINK) $(CAMLDEBUG) $(CAMLFLAGS) $(CAMLPKGS) -a -o $@ $^

$(MLPACKFILES:.mlpack=.cmo): %.cmo: | %.mlpack
	$(SHOW)'CAMLC -pack -o $@'
	$(HIDE)$(TIMER) $(CAMLLINK) $(CAMLDEBUG) $(CAMLFLAGS) -pack -o $@ $^

$(MLPACKFILES:.mlpack=.cmx): %.cmx: | %.mlpack
	$(SHOW)'CAMLOPT -pack -o $@'
	$(HIDE)$(TIMER) $(CAMLOPTLINK) $(CAMLDEBUG) $(CAMLFLAGS) -pack -o $@ $^

# This rule is for _CoqProject with no .mllib nor .mlpack
$(filter-out $(MLLIBFILES:.mllib=.cmxs) $(MLPACKFILES:.mlpack=.cmxs) $(addsuffix .cmxs,$(PACKEDFILES)) $(addsuffix .cmxs,$(LIBEDFILES)),$(MLFILES:.ml=.cmxs) $(MLGFILES:.mlg=.cmxs)): %.cmxs: %.cmx
	$(SHOW)'[deprecated,use-mllib-or-mlpack] CAMLOPT -shared -o $@'
	$(HIDE)$(TIMER) $(CAMLOPTLINK) $(CAMLDEBUG) $(CAMLFLAGS) $(CAMLPKGS) \
		-shared -o $@ $<

ifneq (,$(TIMING))
TIMING_EXTRA = > $<.$(TIMING_EXT)
else
TIMING_EXTRA =
endif

$(VOFILES): %.vo: %.v | $(VDFILE)
	$(SHOW)COQC $<
	$(HIDE)$(TIMER) $(COQC) $(COQDEBUG) $(TIMING_ARG) $(COQFLAGS) $(COQLIBS) $< $(TIMING_EXTRA)
ifeq ($(COQDONATIVE), "yes")
	$(SHOW)COQNATIVE $@
	$(HIDE)$(COQNATIVE) $(COQLIBS) $@
endif

# FIXME ?merge with .vo / .vio ?
$(GLOBFILES): %.glob: %.v
	$(TIMER) $(COQC) $(COQDEBUG) $(COQFLAGS) $(COQLIBS) $<

$(VFILES:.v=.vio): %.vio: %.v
	$(SHOW)COQC -vio $<
	$(HIDE)$(TIMER) $(COQC) -vio $(COQDEBUG) $(COQFLAGS) $(COQLIBS) $<

$(VFILES:.v=.vos): %.vos: %.v
	$(SHOW)COQC -vos $<
	$(HIDE)$(TIMER) $(COQC) -vos $(COQDEBUG) $(COQFLAGS) $(COQLIBS) $<

$(VFILES:.v=.vok): %.vok: %.v
	$(SHOW)COQC -vok $<
	$(HIDE)$(TIMER) $(COQC) -vok $(COQDEBUG) $(COQFLAGS) $(COQLIBS) $<

$(addsuffix .timing.diff,$(VFILES)): %.timing.diff : %.before-timing %.after-timing
	$(SHOW)PYTHON TIMING-DIFF $*.{before,after}-timing
	$(HIDE)$(MAKE) --no-print-directory -f "$(SELF)" print-pretty-single-time-diff BEFORE=$*.before-timing AFTER=$*.after-timing TIME_OF_PRETTY_BUILD_FILE="$@"

$(BEAUTYFILES): %.v.beautified: %.v
	$(SHOW)'BEAUTIFY $<'
	$(HIDE)$(TIMER) $(COQC) $(COQDEBUG) $(COQFLAGS) $(COQLIBS) -beautify $<

$(TEXFILES): %.tex: %.v
	$(SHOW)'COQDOC -latex $<'
	$(HIDE)$(COQDOC) $(COQDOCFLAGS) -latex $< -o $@

$(GTEXFILES): %.g.tex: %.v
	$(SHOW)'COQDOC -latex -g $<'
	$(HIDE)$(COQDOC) $(COQDOCFLAGS) -latex -g $< -o $@

$(HTMLFILES): %.html: %.v %.glob
	$(SHOW)'COQDOC -html $<'
	$(HIDE)$(COQDOC) $(COQDOCFLAGS) -html $< -o $@

$(GHTMLFILES): %.g.html: %.v %.glob
	$(SHOW)'COQDOC -html -g $<'
	$(HIDE)$(COQDOC) $(COQDOCFLAGS)  -html -g $< -o $@

# Dependency files ############################################################

ifndef MAKECMDGOALS
  -include $(ALLDFILES)
else
  ifneq ($(filter-out archclean clean cleanall printenv make-pretty-timed make-pretty-timed-before make-pretty-timed-after print-pretty-timed print-pretty-timed-diff print-pretty-single-time-diff,$(MAKECMDGOALS)),)
   -include $(ALLDFILES)
 endif
endif

.SECONDARY: $(ALLDFILES)

redir_if_ok = > "$@" || ( RV=$$?; rm -f "$@"; exit $$RV )

GENMLFILES:=$(MLGFILES:.mlg=.ml)
$(addsuffix .d,$(ALLSRCFILES)): $(GENMLFILES)

$(addsuffix .d,$(MLIFILES)): %.mli.d: %.mli
	$(SHOW)'CAMLDEP $<'
	$(HIDE)$(CAMLDEP) $(OCAMLLIBS) "$<" $(redir_if_ok)

$(addsuffix .d,$(MLGFILES)): %.mlg.d: %.ml
	$(SHOW)'CAMLDEP $<'
	$(HIDE)$(CAMLDEP) $(OCAMLLIBS) "$<" $(redir_if_ok)

$(addsuffix .d,$(MLFILES)): %.ml.d: %.ml
	$(SHOW)'CAMLDEP $<'
	$(HIDE)$(CAMLDEP) $(OCAMLLIBS) "$<" $(redir_if_ok)

$(addsuffix .d,$(MLLIBFILES)): %.mllib.d: %.mllib
	$(SHOW)'OCAMLLIBDEP $<'
	$(HIDE)$(OCAMLLIBDEP) -c $(OCAMLLIBS) "$<" $(redir_if_ok)

$(addsuffix .d,$(MLPACKFILES)): %.mlpack.d: %.mlpack
	$(SHOW)'OCAMLLIBDEP $<'
	$(HIDE)$(OCAMLLIBDEP) -c $(OCAMLLIBS) "$<" $(redir_if_ok)

# If this makefile is created using a _CoqProject we have coqdep get
# options from it. This avoids argument length limits for pathological
# projects. Note that extra options might be on the command line.
VDFILE_FLAGS:=$(if _CoqProject,-f _CoqProject,) $(CMDLINE_COQLIBS) $(CMDLINE_VFILES)

$(VDFILE): _CoqProject $(VFILES)
	$(SHOW)'COQDEP VFILES'
	$(HIDE)$(COQDEP) -vos -dyndep var $(VDFILE_FLAGS) $(redir_if_ok)

# Misc ########################################################################

byte:
	$(HIDE)$(MAKE) all "OPT:=-byte" -f "$(SELF)"
.PHONY: byte

opt:
	$(HIDE)$(MAKE) all "OPT:=-opt" -f "$(SELF)"
.PHONY:	opt

# This is deprecated.  To extend this makefile use
# extension points and Makefile.local
printenv::
	$(warning printenv is deprecated)
	$(warning write extensions in Makefile.local or include Makefile.conf)
	@echo 'COQLIB = $(COQLIB)'
	@echo 'COQCORELIB = $(COQCORELIB)'
	@echo 'DOCDIR = $(DOCDIR)'
	@echo 'OCAMLFIND = $(OCAMLFIND)'
	@echo 'HASNATDYNLINK = $(HASNATDYNLINK)'
	@echo 'SRC_SUBDIRS = $(SRC_SUBDIRS)'
	@echo 'COQ_SRC_SUBDIRS = $(COQ_SRC_SUBDIRS)'
	@echo 'COQCORE_SRC_SUBDIRS = $(COQCORE_SRC_SUBDIRS)'
	@echo 'OCAMLFIND = $(OCAMLFIND)'
	@echo 'PP = $(PP)'
	@echo 'COQFLAGS = $(COQFLAGS)'
	@echo 'COQLIB = $(COQLIBS)'
	@echo 'COQLIBINSTALL = $(COQLIBINSTALL)'
	@echo 'COQDOCINSTALL = $(COQDOCINSTALL)'
.PHONY:	printenv

# Generate a .merlin file.  If you need to append directives to this
# file you can extend the merlin-hook target in Makefile.local
.merlin:
	$(SHOW)'FILL .merlin'
	$(HIDE)echo 'FLG $(COQMF_CAMLFLAGS)' > .merlin
	$(HIDE)echo 'B $(COQCORELIB)' >> .merlin
	$(HIDE)echo 'S $(COQCORELIB)' >> .merlin
	$(HIDE)$(foreach d,$(COQCORE_SRC_SUBDIRS), \
		echo 'B $(COQCORELIB)$(d)' >> .merlin;)
	$(HIDE)$(foreach d,$(COQ_SRC_SUBDIRS), \
		echo 'S $(COQLIB)$(d)' >> .merlin;)
	$(HIDE)$(foreach d,$(SRC_SUBDIRS), echo 'B $(d)' >> .merlin;)
	$(HIDE)$(foreach d,$(SRC_SUBDIRS), echo 'S $(d)' >> .merlin;)
	$(HIDE)$(MAKE) merlin-hook -f "$(SELF)"
.PHONY: merlin

merlin-hook::
	@# Extension point
.PHONY: merlin-hook

# prints all variables
debug:
	$(foreach v,\
		$(sort $(filter-out $(INITIAL_VARS) INITIAL_VARS,\
	       		$(.VARIABLES))),\
	       	$(info $(v) = $($(v))))
.PHONY: debug

.DEFAULT_GOAL := all

# Users can create Makefile.local-late to hook into double-colon rules
# or add other needed Makefile code, using defined
# variables if necessary.
-include Makefile.local-late

# Local Variables:
# mode: makefile-gmake
# End:
