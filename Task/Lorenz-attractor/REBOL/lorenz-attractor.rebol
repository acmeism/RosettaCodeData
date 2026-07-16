Rebol [
    title: "Rosetta code: Lorenz attractor"
    file:  %Lorenz_attractor.r3
    url:   https://rosettacode.org/wiki/Lorenz_attractor
    needs: blend2d
]

lorenz: object [
    sigma:    10.0
    rho:      28.0
    beta:     8.0 / 3.0
    x:        0.01
    y:        0.0
    z:        0.0
    dt:       0.005
    scale:    13
    offset-x: 400
    offset-y: 400
    prev:     none
    clr:      0.0.0.200

    next: does [
        x: x + ( dt * sigma * (y - x)      )
        y: y + ( dt * (x * (rho - z) - y)  )
        z: z + ( dt * (x * y - (beta * z)) )
        as-pair x * scale + offset-x y * scale + offset-y
    ]

    line: does [
        if none? prev [prev: next]
        clr/1: z * 5
        clr/2: 255 - ((x + 30) * 4.25)
        clr/3: 255 - ((y + 30) * 4.25)
        compose [pen (clr) line (prev) (prev: next)]
    ]
]

img: make image! [800x800 0.0.0]
lines: [line-width 2]
loop 20000 [ append lines lorenz/line ]

browse save %Lorenz_attractor.png draw img lines
