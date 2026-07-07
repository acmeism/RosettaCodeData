Rebol [
    title: "Rosetta code: Julia set"
    file:  %Julia_set.r3
    url:   https://rosettacode.org/wiki/Julia_set
]

julia: function [size [pair!]][
    W: to integer! size/x W2: W / 2
    H: to integer! size/y H2: H / 2
    Zoom: 1
    MaxIter: 255
    MoveX: MoveY: 0
    Cx: -0.7
    Cy:  0.27015

    ;; precompute color palette
    colors: copy []
    clr: 0.0.0
    for i 0 255 1 [
        clr/1:  i >> 5 * 36
        clr/2: (i >> 3 & 7) * 36
        clr/3: (i & 3) * 85
        append colors clr
    ]

    img: make image! size
    scaleX: 1.5 / (0.5 * Zoom * W)
    scaleY: 1.0 / (0.5 * Zoom * H)

    for x 0 W - 1 1 [
        for y 0 H - 1 1 [
            zx: (x - W2) * scaleX + MoveX
            zy: (y - H2) * scaleY + MoveY
            i:  MaxIter
            while [all [
                i > 1
                (zx*zx: zx * zx) + (zy*zy: zy * zy) < 4.0
            ]][
                zx2: zx*zx - zy*zy + Cx
                zy:  2.0 * zx * zy + Cy
                zx:  zx2
                -- i
            ]
            pokez img (y * W + x) colors/:i
        ]
    ]
    img
]

browse save %Julia_set.png julia 800x600
