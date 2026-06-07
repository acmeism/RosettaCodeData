Red [
title: "Statistics"
author: "hinjolicious"
]

;#include %mylib.red
;#include %pipe-map.red
#include %tabulize.red  ; https://gist.github.com/hinjolicious/4cfa52e3b4bccaecfff9c76e97a7b546
#include %plotter.red   ; https://gist.github.com/hinjolicious/2049362edc848844a904002bd37910ba

;=== STATS LIB ===

; number list generator
number-gen: function [min max num][
	random/seed now/time/precise
	collect [ loop num [ keep min + random (max - min) ]]
]

; count of items (built-in!)
count: :length?

; mean (built-in!)
mean: :average

; variance
variance: function [x[series!] /pop /set-mean m0[number!]] [
; /pop : do population mean instead of sample
; /set-mean : set mean to m0
	m: either set-mean [m0][mean x]
	( sx: 0  foreach xi x [ sx: sx + ((xi - m) ** 2)] ) / ( (count x) - either pop [0][1] )
]

; standard deviation
stddev: function [x[series!] /pop /set-mean m0[number!]] [
; /pop : population
; /set-mean : set mean to m0
	m: either set-mean [m0] [mean x]
	sqrt variance/set-mean/:pop x m
]

list: reduce [
	number-gen 0.0 1.0 100
	number-gen 0.0 1.0 1000
	number-gen 0.0 1.0 10000
	number-gen 0.0 1.0 100000 ]

print "Random Number Test"	
print [pad "Items" 10 pad "Mean" 20 pad "StdDev" 20]
foreach nums list [
	print [pad count nums 10 pad mean nums 20 pad stddev nums 20]
]

; visualize

;do %plotter.red

foreach nums list [
	tab: tabulize/plot-output/set-min/set-max nums 25 0.0 1.0

	demo-data: compose/deep [ [[histogram "Randoms" sky dot 0.7 fit red 2] [(tab)]] ]

	; 2. (Optional) Inherit or change properties on the fly
	chart-engine: make PLOTTER [
		plot-config/margin: 50x40 ; Alter padding just for this module instance
	]

	view compose/deep [
		title "Random Number Test"
		canvas: base 600x400 white
		do [
			canvas/draw: chart-engine/plot/title/x-label/y-label/x-range
				600x400
				demo-data
				(rejoin ["Random Number - " length? nums " items"])
				"Sample"
				"Frequency"
				[-0.05 1.05]
		]
	]
]
