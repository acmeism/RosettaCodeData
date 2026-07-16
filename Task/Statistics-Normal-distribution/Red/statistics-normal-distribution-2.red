Red []

#include %../stats.red
#include %../freq-dist.red
#include %../num-gen.red
#include %../ziggurat.red
#include %../../plotter/plotter.red
#include %../../plotter/nice-range.red
#include %../../plotter/nice-bands.red

gen-ziggurat: function [n][collect [loop n [keep seq-ziggurat]]]

list: reduce [
	"Normal" gen-ziggurat 100
	"Normal" gen-ziggurat 100000
]

; visualize
foreach [ttl nums] list [
	;tab: freq-dist/plot-output/set-min/set-max nums 25 0.0 1.0
	tab: freq-dist/plot-output nums 25

	demo-data: compose/deep [ [[histogram (ttl) sky dot 0.7 normal-fit red 2] [(tab)]] ]

	chart-engine: make PLOTTER [
		plot-config/margin: 50x40 ; Alter padding just for this module instance
	]

	view compose/deep [
		title (ttl)
		canvas: base 600x400 white
		do [
			canvas/draw: chart-engine/plot/title/x-label/y-label ;/x-range
				600x400
				demo-data
				(rejoin [(ttl) " - " length? nums " items"])
				rejoin ["Sample (mean " mean nums " stddev: " stddev nums ")"]
				"Frequency"
		]
	]
]
