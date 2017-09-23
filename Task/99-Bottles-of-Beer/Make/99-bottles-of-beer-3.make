digits:=9 8 7 6 5 4 3 2 1 0
numbers:=$(foreach x,$(filter-out 0,$(digits)),$(foreach y,$(digits),$x$y))
numbers+=$(digits)

bottles=bottle$(if $(findstring /1/,$@),,s)
num=$(if $(findstring /0/,$@),$(empty),$(@F))
action=$(if $(findstring /0/,$@),$(buy),$(pass))

beer:=of beer
wall:=on the wall
empty:=No more
pass:=Take one down and pass it around.
buy:=Go to the store and buy some more.

# Function to generate targets for each verse of the song.
define verse
.PHONY: $1
$1: verse/$1/$1 prelude/$2/$2 $2

.PHONY: $1-bottles
$1-bottles: $1

most?=$1
endef

# Recursive function that loops through the 100 numbers.
define verses
$$(eval $$(call verse,$$(word 1,$1),$$(word 2,$1)))
$$(if $$(word 2,$1),$$(eval $$(call verses,$$(filter-out $$(word 1,$1),$1))))
endef

# Generate the targets for the 100 numbers.
$(eval $(call verses,$(numbers)))


# Main lines in the verse.
.PHONY: verse/%
verse/%:
	@echo "$(num) $(bottles) $(beer) $(wall)."
	@echo "$(num) $(bottles) $(beer)."
	@echo "$(action)"

# Last line of a verse, which is a prelude to the next verse.
.PHONY: prelude/%
prelude/%:
	@echo "$(num) $(bottles) $(beer) $(wall)."
	@echo ""

# Special target for the last line of the song.
.PHONY: prelude/
prelude/:
	@echo "$(most) $(bottles) $(beer) $(wall)!"
	@echo ""
