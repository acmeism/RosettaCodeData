Red [
    Purpose: "One-dimensional cellular automata"
    Author: "Joe Smith"
]

vals: [0 1 0]
kill: [[0 0] [#[none] 0] [0 #[none]]]
evo: function [petri] [
	new-petri: copy petri
	while [petri/1] [
		if all [petri/-1 = 1 petri/2 = 1] [new-petri/1: select vals petri/1]
		if find/only kill reduce [petri/-1 petri/2] [new-petri/1: 0]
		petri: next petri new-petri: next new-petri
	]
	petri: head petri new-petri: head new-petri
	clear insert petri new-petri
]

display: function [petri] [
	print replace/all (replace/all to-string petri "0" "_") "1" "#"
	petri	
]

loop 10 [
	evo display [1 1 1 0 1 1 0 1 0 1 0 1 0 1 0 0 1 0]
]
