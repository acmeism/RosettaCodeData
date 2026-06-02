Red [
   Title: "3D Perspective Cube with rotation and zoom"
   Author: "hinjolicious"
   Resources: "Red Sensei, Toomasv"
]

; Cube vertices (centered at origin)
verts: [
; cube
;    [-1 -1 -1] [1 -1 -1] [1 1 -1] [-1 1 -1]
;    [-1 -1  1] [1 -1  1] [1 1  1] [-1 1  1]
; relatively 2x3x4
    [-1 -1.5 -2] [1 -1.5 -2] [1 1.5 -2] [-1 1.5 -2]
    [-1 -1.5  2] [1 -1.5  2] [1 1.5  2] [-1 1.5  2]
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
cam-z: -5.0

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

view [
    title "3D Perspective Cube"
    canvas: base 400x400 white draw (draw-cube)
    below
    text "Rotate X:"
    slider 200 [ax: 6.28 * to float! face/data  canvas/draw: draw-cube]
    text "Rotate Y:"
    slider 200 [ay: 6.28 * to float! face/data  canvas/draw: draw-cube]
    text "Rotate Z:"
    slider 200 [az: 6.28 * to float! face/data  canvas/draw: draw-cube]
    text "Zoom:"
    slider 200 [cam-z: -3.0 - (7.0 * to float! face/data)  canvas/draw: draw-cube]
]

