# Using the "Makes" Makefile framework
R := https://github.com/makeplus/makes
M := .cache/makes
$(shell [ -d '$M' ] || git clone -q $R '$M')

include $M/init.mk
include $M/perl.mk
include $M/clean.mk
include $M/shell.mk

ROSETTACODE := $(PERL-BIN)/rosettacode

SHELL-DEPS += $(ROSETTACODE)

MAKES-CLEAN := Meta/ rosettacode.log

build: $(ROSETTACODE)
	time rosettacode

$(ROSETTACODE): $(PERL)
	cpanm -n RosettaCode
	touch $@
