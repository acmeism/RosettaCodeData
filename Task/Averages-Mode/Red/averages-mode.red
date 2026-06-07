Red [
	title: "Mode - return one or more modes"
	author: "hinjolicious"
]

; most occured items
modes: function [xx[series!]] [
	x: sort copy xx
	v: first x  c: 1
	last-v: v  last-c: 0
	mm: copy []
	foreach xi next x [
		either xi = v [c: c + 1][
			either c > last-c [last-c: c  clear mm  append mm v]
				[if c = last-c [append mm v]]
			v: xi  c: 1
		]
	]
	either c > last-c [mm: reduce [v]]
		[if c = last-c [append mm v]]
	mm
]

; mode tests:
foreach n [5 10 15 20] [
	print ["^/Numbers:" mold x: num-gen n]
	print ["Sorted:" mold sort x]
	print ["Count:" n "Mode(s):" mold modes x]
]
