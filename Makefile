SHELL := bash

default:

build:
	time rosettacode

clean:
	$(RM) -r Meta/ rosettacode.log
