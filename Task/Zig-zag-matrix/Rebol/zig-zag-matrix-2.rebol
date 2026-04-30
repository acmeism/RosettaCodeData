zig-zag-matrix: function [size [integer!]][
    matrix: array/initial len: size * size 0  ;; Flat array, row-major
    x: 0 dx: -1
    y: 0 dy:  1
    repeat i len [
        case [
            x >= size [-- x y: y + 2 dx: negate dx dy: negate dy]
            y >= size [-- y x: x + 2 dx: negate dx dy: negate dy]
            all [y >= 0 x < 0][++ x  dx: negate dx dy: negate dy]
            all [x >= 0 y < 0][++ y  dx: negate dx dy: negate dy]
        ]
        matrix/(y * size + x + 1): i - 1
        x: x + dx
        y: y + dy
    ]
    new-line/skip matrix true size
    matrix
]
