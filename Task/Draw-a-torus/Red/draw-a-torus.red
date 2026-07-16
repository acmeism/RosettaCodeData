Red [
	title: "Draw a torus"
	author: "hinjolicious"
	needs: 'view
	note: "Adapted of Wren's example"
]

torus: function [] [
	Rext: 150	; outer radius
	Rint: 60	; tube radius
	
	A: 0.5	; x rotation (radians)
	B: 0.5	; z rotation
	
	sinA: sin A
	cosA: cos A
	sinB: sin B
	cosB: cos B
	
	cx: 320
	cy: 330
	scale: 600
	px: 1
	
	drawings: [pen off]
	
	jj: 0.0 while [jj <= 628] [
		j: jj / 100
		ii: 0.0 while [ii <= 628] [
			i: ii / 100
			sini: sin i
			cosi: cos i
			sinj: sin j
			cosj: cos j
			
			; 3d coord calc
			h: Rext + (Rint * cosj)
			x: h * (cosB * cosi + (sinA * sinB * sini)) - (Rint * cosA * sinB * sinj)
			y: h * (sinB * cosi - (sinA * cosB * sini)) + (Rint * cosA * cosB * sinj)
			z: h *  cosA * sini + (Rint * sinA * sinj)
			
			; luminance calc (dot product with light source - top-front)
			tmp: cosj * cosi * sinB - (sinA * cosj * sini * cosB) - (cosA * sinj * cosB)
			lum: 8 * (tmp - (cosi * sinj * sinA))
			
			if lum > 0 [
				; set color based on brightness
				br: min 255 to-integer lum * 30
				clr: as-color to-integer br / 2 br 255

				; project to 2d
				ooz: 1 / (z + 500) ; depth feeling
				x: cx + (x * ooz * scale)
				y: cy - (y * ooz * scale)

				append drawings compose [fill-pen (clr) circle (as-pair x y) (px)]
		]	
		ii: ii + 3
		]
	jj: jj + 1
	]
	drawings
]

my-torus: torus

view/tight [
	title "Red's Draw a Torus"
	canvas: base 600x600 black
	draw my-torus
]
