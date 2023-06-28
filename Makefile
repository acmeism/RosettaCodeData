SHELL := bash

default:

build:
	time rosettacode sync

force: clean
	$(RM) -r Lang/ Task/

clean:
	$(RM) -r Meta/ rosettacode.log
