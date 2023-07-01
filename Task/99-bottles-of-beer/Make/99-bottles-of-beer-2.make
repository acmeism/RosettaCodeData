PRED=`expr $* - 1`

1-bottles: 1-beer pass
	@echo "No more bottles of beer on the wall"

%-bottles: %-beer pass
	@echo "$(PRED) bottles of beer on the wall\n"
	@-$(MAKE) $(PRED)-bottles

1-beer:
	@echo "One bottle of beer on the wall, One bottle of beer"

%-beer:
	@echo "$* bottles of beer on the wall, $* bottles of beer"

pass:
	@echo "Take one down and pass it around,"
