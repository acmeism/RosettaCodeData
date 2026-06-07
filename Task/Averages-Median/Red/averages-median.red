Red [title: "Median" author: "hinjolicious"]

; middle value when sorted
median: function [xx[series!]] [
	x: sort copy xx
	n: count xx
	either odd? n [ x/((n + 1) / 2) ]
		[ ( x/(n / 2)  +  x/((n / 2) + 1) ) / 2 ]
]

; tests:
foreach n [5 10 15 20] [
	print ["^/Numbers:" mold x: num-gen n]
	print ["Sorted:" mold sort x]
	print ["Count:" n "(" either even? n ["Even"]["Odd"] ") Median:" median x]
]
