Rebol [
    title: "Rosetta code: Munching squares"
    file:  %Munching_squares.r3
    url:   https://rosettacode.org/wiki/Munching_squares
]

img: make image! 256x256

clr: 0.0.0
for x 0 255 1 [
    for y 0 255 1 [
        clr/2: x xor y
        pokez img (y * 256 + x) clr
    ]
]
img: resize img 200%
browse save %Munching_squares.png img
