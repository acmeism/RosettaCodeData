# Using the "Makes" Makefile framework
R := https://github.com/makeplus/makes
M := .cache/makes
$(shell [ -d '$M' ] || git clone -q $R '$M')

include $M/init.mk
include $M/ys.mk
include $M/clean.mk
include $M/shell.mk

MAKES-CLEAN := Meta/ rosettacode.log rosettacode-errors.log
MAKES-DISTCLEAN += Cache .clj-kondo .lsp

override PATH := $(ROOT)/bin:$(PATH)
export PATH


build: $(YS)
	time bin/rcd-sync
