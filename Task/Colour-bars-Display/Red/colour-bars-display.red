Red [
	title: "Color bars/Display"
	author: "hinjolicious"
	needs: 'view
]

w: 1920
h: 1080
colors: [black red green blue magenta cyan yellow white]

n: length? colors
gap: w / n
drawing: [pen off]
append drawing collect [
	repeat i n [
		tl: as-pair (i - 1) * gap 0
		br: tl + as-pair gap h
		keep compose [fill-pen (colors/:i) box (tl) (br)]
	]	
]

view/tight/flags [
	base with [size: as-pair w h]
	draw drawing
]
[no-title no-border]
