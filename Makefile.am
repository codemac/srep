## srep -- scheme grep
## Copyright © 2015 Jeff Mickey <j@codemac.net>


GOBJECTS = $(SOURCES:%.scm=%.go)

nobase_mod_DATA = $(SOURCES) $(NOCOMP_SOURCES)
nobase_go_DATA = $(GOBJECTS)

# Make sure source files are installed first, so that the mtime of
# installed compiled files is greater than that of installed source
# files.  See
# <http://lists.gnu.org/archive/html/guile-devel/2010-07/msg00125.html>
# for details.
guile_install_go_files = install-nobase_goDATA
$(guile_install_go_files): install-nobase_modDATA

CLEANFILES = $(GOBJECTS)
EXTRA_DIST = $(SOURCES) $(NOCOMP_SOURCES)
GUILE_WARNINGS = -Wunbound-variable -Warity-mismatch -Wformat
SUFFIXES = .scm .go
.scm.go:
	$(AM_V_GEN)$(top_builddir)/pre-inst-env $(GUILE_TOOLS) compile $(GUILE_WARNINGS) -o "$@" "$<"

moddir=$(prefix)/share/guile/site/2.0
godir=$(libdir)/guile/2.0/ccache

bin_SCRIPTS =					\
  scripts/srep

SOURCES =					\

AM_SCM_LOG_FLAGS = --no-auto-compile -L "$(top_srcdir)"

info_TEXINFOS = doc/srep.texi

EXTRA_DIST +=					\
  pre-inst-env.in				\
  README					\
  guix.scm

SUBDIRS =					\
