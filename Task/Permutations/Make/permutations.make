#delimiter should not occur inside elements
delimiter=;
#convert list to delimiter separated string
implode=$(subst $() $(),$(delimiter),$(strip $1))
#convert delimiter separated string to list
explode=$(strip $(subst $(delimiter), ,$1))
#enumerate all permutations and subpermutations
permutations0=$(if $1,$(foreach x,$1,$x $(addprefix $x$(delimiter),$(call permutations0,$(filter-out $x,$1)))),)
#remove subpermutations from permutations0 output
permutations=$(strip $(foreach x,$(call permutations0,$1),$(if $(filter $(words $1),$(words $(call explode,$x))),$(call implode,$(call explode,$x)),)))

delimiter_separated_output=$(call permutations,a b c d)
$(info $(delimiter_separated_output))
