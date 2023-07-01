Red [
	Source:     https://github.com/vazub/rosetta-red
	Tabs:       4
	Needs:       'View
]

canvas: 500x500
center: as-pair canvas/x / 2 canvas/y / 2
radius: 200

points: collect [
	repeat vertex 10 [
		angle: vertex * 36 + 18 ;-- +18 is required for pentagram rotation
		either vertex // 2 = 1 [
			keep as-pair (cosine angle) * radius + center/x (sine angle) * radius + center/y
		][
			keep as-pair (cosine angle) * radius * 0.382 + center/x (sine angle) * radius * 0.382 + center/y
		]
	]
]

view [
	title "Pentagram"
	base canvas white
	draw compose/deep [
		fill-pen mint
		polygon (points)
		line-width 3
		line (points/1) (points/5) (points/9) (points/3) (points/7) (points/1)
	]
]
