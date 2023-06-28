SHELL := bash

default:

build:
	time rosettacode sync

clean:
	$(RM) -r Meta/ rosettacode.log
