START = 99
UP != jot - 2 `expr $(START) - 1` 1

0-bottles-of-beer: 1-bottle-of-beer
	@echo No more bottles of beer on the wall!

1-bottle-of-beer: 2-bottles-of-beer
	@echo One last bottle of beer on the wall!
	@echo
	@echo One last bottle of beer on the wall,
	@echo One last bottle of beer,
	@echo Take it down, pass it around.

.for COUNT in $(UP)
ONE_MORE != expr 1 + $(COUNT)
$(COUNT)-bottles-of-beer: $(ONE_MORE)-bottles-of-beer
	@echo $(COUNT) bottles of beer on the wall!
	@echo
	@echo $(COUNT) bottles of beer on the wall,
	@echo $(COUNT) bottles of beer,
	@echo Take one down, pass it around.
.endfor

$(START)-bottles-of-beer:
	@echo $(START) bottles of beer on the wall,
	@echo $(START) bottles of beer.
	@echo Take one down, pass it around.
