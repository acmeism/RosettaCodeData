import blend2d
mosaic-matrix: function [size [integer! pair!]][
    if integer? size [size: as-pair size size]
    pattern: draw 20x20 [
        pen none
        fill 127.127.127.127 ;; semi-transparent gray
        box  0x0  10x10
        box 10x10 20x20
    ]
    draw size * 10 [fill :pattern fill-all]
]
save %mosaic.png mosaic-matrix 50x50
