# Langton's ant Makefile
# netpbm is an ancient collection of picture file formats
# convert and display are from imagemagick
.PHONY: display
display: ant.png
	display $<
ant.png: ant.pbm
	convert $< $@

n9:=1 2 3 4 5 6 7 8 9
n100:=$(n9) $(foreach i,$(n9),$(foreach j,0 $(n9),$i$j)) 100
ndec:=0 $(n100)
ninc:=$(wordlist 2,99,$(n100))
$(foreach i,$(n100),$(eval row$i:=$(foreach j,$(n100),0)))

.PHONY: $(foreach i,$(ndec),row$i)
row0:
	@echo  >ant.pbm P1
	@echo >>ant.pbm '#' Langton"'"s ant
	@echo >>ant.pbm 100 100
rowrule=row$i: row$(word $i,$(ndec)); @echo >>ant.pbm $$($$@)
$(foreach i,$(n100),$(eval $(rowrule)))
ant.pbm: Makefile row100
	@:

x:=50
y:=50
direction:=1

turn=$(eval direction:=$(t$(xy)$(direction)))
xy=$(word $x,$(row$y))
t01:=4
t02:=1
t03:=2
t04:=3
t11:=2
t12:=3
t13:=4
t14:=1

flip=$(eval row$y:=$(start) $(not$(xy)) $(end))
start=$(wordlist 1,$(word $x,$(ndec)),$(row$y))
not0:=1
not1:=0
end=$(wordlist $(word $x,$(ninc) 100),100,$(row$y))

step=$(eval $(step$(direction)))
step1=y:=$(word $y,exit $(n100))
step2=x:=$(word $x,$(ninc) exit)
step3=y:=$(word $y,$(ninc) exit)
step4=x:=$(word $x,exit $(n100))

iteration=$(if $(filter exit,$x $y),,$(turn)$(flip)$(step))
$(foreach i,$(n100) $(n100),$(foreach j,$(n100),$(iteration)))
