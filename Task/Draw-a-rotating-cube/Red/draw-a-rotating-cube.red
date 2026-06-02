Red [
	Title: "Rotating 3D Cube with Zoom"
	Author: "hinjolicious"
	Resources: "Red Sensei, Toomasv"
]

; Cube vertices (centered at origin)
verts: [
; cube
    [-1 -1 -1] [1 -1 -1] [1 1 -1] [-1 1 -1]
    [-1 -1  1] [1 -1  1] [1 1  1] [-1 1  1]
]

; Face indices (4 corners each)
faces-idx: [
    [1 2 3 4] [5 6 7 8] [1 5 6 2]
    [4 3 7 8] [1 4 8 5] [2 6 7 3]
]

; Face colors
colors: [red green blue yellow cyan magenta]

; Rotation angles and camera
ax: 0.5  ay: 0.4  az: 0.0
cam-z: -4.0

; Rotate point around X, Y, and Z axes
rotate: func [p /local x y z x1 y1 z1 x2 z2 x3 y3][
    x: p/1  y: p/2  z: p/3
    ; Rotate around X
    y1: (y * cos ax) - (z * sin ax)
    z1: (y * sin ax) + (z * cos ax)
    ; Rotate around Y
    x2: (x * cos ay) - (z1 * sin ay)
    z2: (x * sin ay) + (z1 * cos ay)
    ; Rotate around Z
    x3: (x2 * cos az) - (y1 * sin az)
    y3: (x2 * sin az) + (y1 * cos az)
    reduce [x3 y3 z2]
]

; Project 3D to 2D with perspective
project: func [p /local z scale][
    z: p/3 - cam-z
    if z < 0.1 [z: 0.1]
    scale: 200.0 / z
    as-pair (200 + to integer! (p/1 * scale)) (200 + to integer! (p/2 * scale))
]

; Average Z for face sorting
face-z: func [pts indices /local sum pt][
    sum: 0.0
    repeat i 4 [
        pt: pick pts indices/:i
        sum: sum + pt/3
    ]
    sum / 4.0
]

draw-cube: func [/local pts sorted cmd i f c][
    pts: collect [foreach v verts [keep/only rotate v]]

    ; Build face list with z-depth
    sorted: collect [
        repeat i 6 [
            keep/only reduce [face-z pts faces-idx/:i  i]
        ]
    ]
    ; Sort by z (painter's algorithm - draw far faces first)
    sort/compare sorted func [a b][a/1 > b/1]

    ; Build draw commands
    cmd: copy []
    foreach item sorted [
        i: item/2
        f: faces-idx/:i
        c: colors/:i
        append cmd compose [
            fill-pen (c)
            polygon (project pts/(f/1)) (project pts/(f/2))
                    (project pts/(f/3)) (project pts/(f/4))
        ]
    ]
    cmd
]

; Add rotation speed variables (degrees per frame)
speed-x: 0.02
speed-y: 0.02
speed-z: 0.02

; Current angles
ax: 0.0
ay: 0.0
az: 0.0

view [
    title "3D Rotating Cube"

    base 400x400 gray
        rate 60                          ; <-- Timer: 60 frames per second
        draw [pen white]
        on-time [
            ; Update angles
            ax: ax + speed-x
            ay: ay + speed-y
            az: az + speed-z

            ; Keep angles in 0-360 range (optional, prevents overflow)
            if ax >= 360.0 [ax: ax - 360.0]
            if ay >= 360.0 [ay: ay - 360.0]
            if az >= 360.0 [az: az - 360.0]

            ; Update sliders to show current angles (optional)
            sx/data: ax / 360.0
            sy/data: ay / 360.0
            sz/data: az / 360.0

            ; Redraw the cube
            face/draw: draw-cube ax ay az zoom/data * 800 + 200
        ]

	below
    return
	text "X:" sx: slider 100 [ax: face/data * 360.0]
    text "Y:" sy: slider 100 [ay: face/data * 360.0]
    text "Z:" sz: slider 100 [az: face/data * 360.0]
    ;text "Zoom:" zoom: slider 100 [face/draw: draw-cube ax ay az face/data * 800 + 200]
    text "Zoom:" zoom: slider 100 [cam-z: -3.0 - (7.0 * to float! face/data)  face/draw: draw-cube ax ay az face/data * 800 + 20]	
]
