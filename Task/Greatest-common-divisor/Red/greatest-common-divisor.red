Red [
title: "Greatest Common Divisor"
author: "hinjolicious"
note: "Based on Python and REBOL's example"
]

gcd: function [u[integer!] v[integer!]][
	u: absolute u
	v: absolute v
	while [v > 0][
		uu: u
		u: v
		v: uu // v
	]
	u
]

nums: [
	0 0
	0 10 10 0 -10 0 0 -10
	9 6 6 9 -6 9 9 -6 6 -9 -9 6
	8 45 45 8 -45 8 8 -45 -8 45 45 -8
	40902 24140
]

foreach [a b] nums [print gcd a b]
