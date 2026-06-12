Red [ "Count the occurrence of each digit in e - hinjoliicous"]

; simplified num-gen
num-gen: function [n v][collect [loop n [keep v]]]

n: 4000
v: num-gen n 1
dc: [0 0 1 0 0 0 0 0 0 0]

loop 2 * n [
	a: n + 1
	c: 0
	repeat i n [
		c: c + (v/:i * 10)
		v/(:i): modulo c  a
		c: to-integer c / a
		a: a - 1
	]
	dc/(:c + 1): dc/(:c + 1) + 1
]
?? dc
