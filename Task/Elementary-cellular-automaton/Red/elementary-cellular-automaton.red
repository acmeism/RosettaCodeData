Red [
	title: "Elementary Cellular Automaton (Graphical Visualization)"
	author: "hinjolicious"
	needs: 'view
]

#include %transpose.red
flatten: function [x][collect [foreach e x [keep e]]]

eca: function [nrule state gens sz][
	rule: pad/left/with (enbase/base to-binary to-char nrule 2) 8 #"0"
	pattern: ["111" "110" "101" "100" "011" "010" "001" "000"]
	n:  length? state
	ng: append/dup "" " " n
	t:  append/dup "" " " n
	
	nextgen: func [inp i-1 i i+1 n][
		if i-1 < 1 [i-1: n]
		if i+1 > n [i+1: 1]
		select flatten transpose reduce [pattern rule] rejoin [inp/:i-1 inp/:i inp/:i+1]
	]
	
	rad: sz / 2
	drawing: []
	repeat g gens [
		;print replace/all (replace/all copy state "1" "#") "0" "."
		repeat i n [
			ng/:i: nextgen state (i - 1) i (i + 1) n
			
			; drawing it
			p: as-pair i * sz - rad g * sz - rad
			c: either state/:i = #"1" [green][black]
			append drawing compose [fill-pen (c) circle (p) (rad)]
		]
		t: state
		state: ng
		ng: t
	]
	
	; display drawing
	ttl: rejoin ["ECA Rule: " nrule " Gens: " gens]
	view compose [
		backdrop black
		title (ttl)
		box with [size: as-pair n * sz gens * sz]
		draw drawing
	]
]

state: "0000000000000001000000000000000"
eca 90  copy state 50 7
eca 30  copy state 50 7
eca 122 copy state 50 7
