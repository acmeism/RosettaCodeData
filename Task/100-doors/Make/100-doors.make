.DEFAULT_GOAL:=100
digit=1 2 3 4 5 6 7 8 9
doors:=$(digit) $(foreach i,$(digit),$(foreach j,0 $(digit),$i$j)) 100
$(doors):;@: $(if $(filter %1 %3 %5 %7 %9,$(words $^)),$(info $@))
$(foreach i,$(doors),$(eval $i: $(word $i,0 $(doors))))
0 $(addprefix pass,$(doors)):
pass:=X
dep=$(eval count+=$(pass))$(eval $(words $(count)):pass$(words $(pass)))
loop=$(foreach inner,$(doors),$(if $(word 101,$(count)),,$(dep)))
$(foreach outer,$(doors),$(eval pass+=X)$(eval count:=)$(loop))
