Red [
    Title: "Kronecker Product Based Fractals"
    Author: "hinjolicious"
	Resources: "Red Sensei, Formulae's example, etc."
    Needs: 'View
]

;-- Configuration
iterations: 6
img-size: 3 ** iterations  ; size = matric size ^ iterations (3^6 = 729 for 3x3 matrices and 6 iterations)
;

;-- Define pattern matrices (1 = filled, 0 = empty, fractional = gradual color)
;-- Each matrix can have its own color
patterns: [
    [   matrix: [[0 1 0] ; Vicsek
				 [1 1 1]
				 [0 1 0]]
        color: 255.0.0.255 ] ; red	
    [   matrix: [[1 1 1] ; Sierpinski carpet
				 [1 0 1]
				 [1 1 1]]
        color: 0.0.255.128 ] ; blue
]
;-- Kronecker product of two matrices
kronecker: func [m1 m2 /local count e counter check sub-list n1 n2][
	count: length? m2
	
	collect [	
		foreach e m1 [
			counter: 1
			check: 0
			while [check < count][
				sub-list: collect [
					foreach n1 e [
						foreach n2 m2/:counter [keep n1 * n2]
					]
				]
				keep/only sub-list				
				counter: counter + 1
				check: check + 1
			]
		]
	]
]

;-- Apply Kronecker product n times
kronecker-iterate: func [matrix [block!] n [integer!] /local result][
    result: matrix
	
    loop n - 1 [result: kronecker result matrix]
    result
]

;-- Render fractal
render-fractal: func [matrix [block!] size [integer!] col [tuple!] /local img rows cols scale cm sy sx dy dx][
    rows: length? matrix
    cols: length? matrix/1
    scale: to-integer size / cols

    img: make image! reduce [as-pair size size transparent]

    repeat y rows [
        repeat x cols [
			cm: matrix/:y/:x * col ;mix color with color with fractional values
            if cm/4 > 0 [ ;not transparent
                ;-- Draw a filled square or gradual color
                sy: (y - 1) * scale
                sx: (x - 1) * scale
                repeat dy scale [
                    repeat dx scale [
                        pos: (sy + dy - 1) * size + sx + dx
                        if all [pos > 0 pos <= (size * size)][poke img pos cm]
                    ]
                ]
            ]
        ]
    ]
    img
]

;-- Blend images together
blend-images: func [images [block!] size [integer!] /local result i px c r g b][
    result: make image! reduce [as-pair size size black]

    foreach img images [
        repeat i (size * size) [
            px: pick img i
            if px/4 > 0 [  ;-- If not transparent
                c: pick result i
                ;-- Simple additive blend with alpha
                r: min 255 (c/1 + (px/1 * px/4 / 255))
                g: min 255 (c/2 + (px/2 * px/4 / 255))
                b: min 255 (c/3 + (px/3 * px/4 / 255))
                poke result i make tuple! reduce [r g b]
            ]
        ]
    ]
    result
]

;-- Generate the fractal
generate: func [/local layers fractal-matrix layer-img][
    layers: copy []
    foreach p patterns [
        fractal-matrix: kronecker-iterate p/matrix iterations
        layer-img: render-fractal fractal-matrix img-size p/color
        append layers layer-img
    ]
	blend-images layers img-size
]

img: generate
;-- Display
view [
    title "Kronecker Fractal"
    image img
]
