all: test

test:
	@make -f scriptedmain.mf meaning-of-life
	@echo "(Test)"
