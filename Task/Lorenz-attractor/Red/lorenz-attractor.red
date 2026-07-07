Red [
	title: "lorenz's Attractor"
	author: "hinjolicious"
	needs: 'view
	resource: "Wikipedia"
]

lorenz: object [
	sigma: 10.0
	rho: 28.0
	beta: 8.0 / 3.0	
	x: 0.01
	y: 0.0
	z: 0.0
	dt: 0.01
	scale: 10
	offset-x: 300
	offset-y: 300	
	prev: none
	
	next: func [] [
		x: x + ( dt * sigma * (y - x)      ) ; [-30 30]
		y: y + ( dt * (x * (rho - z) - y)  ) ; [-30 30]
		z: z + ( dt * (x * y - (beta * z)) ) ; [0 50]
		as-pair x * scale + offset-x y * scale + offset-y
	]

	line: func [] [
		if none? prev [prev: next]
		clr: as-color
			to integer! z * 5
			255 - to integer! (x + 30) * 4.25
			255 - to integer! (y + 30) * 4.25
		compose [pen (clr) line (prev) (prev: next)]
	]
]

lines: []

view/tight [
	title "Red's Lorenz Attractor"
	canvas: base 600x600 black
	rate 60	on-time [
		append lines lorenz/line
		if (length? lines) > 30000 [take/part lines 5]
		canvas/draw: lines
	]
]
