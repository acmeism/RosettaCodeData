Rebol [
    title: "Rosetta code: Death Star"
    file:  %Death_Star_ASCII.r3
    url:   https://rosettacode.org/wiki/Death_Star
]

death-star: function/with [pos neg sun k amb] [
    out: clear ""
    for y (pos/y - pos/r - 0.5) (pos/y + pos/r + 0.5) 1 [
        for x (pos/x - pos/r - 0.5) (pos/x + pos/r + 0.5) 0.5 [
            shade: 1 result: 0
            set [hit: pz1: pz2:] hittest pos x y
            if hit [
                set [hit: nz1: nz2:] hittest neg x y
                result: case [
                    any [not hit nz1 > pz1] [1]
                    nz2 > pz2               [0]
                    nz2 > pz1               [2]
                    true                    [1]
                ]
            ]
            if result > 0 [
                n: norm reduce either/only result == 1 [
                    (x - pos/x) (y - pos/y) (pz1 - pos/z)
                ][  (neg/x - x) (neg/y - y) (neg/z - nz2) ]
                shade: 1 + clamp (((dot sun n) ** k) + amb) * 10 1 10
            ]
            append out shades/:shade
        ]
        append out LF
    ]
    out
][
    shades: " .:!*oe&#%@"
    hittest: func [s x y] [
        z: (s/r ** 2) - ((x - s/x) ** 2) - ((y - s/y) ** 2)
        reduce either z >= 0 [
            z: sqrt z
            [true  s/z - z  s/z + z]
        ][  [false 0 0] ]
    ]
    clamp: func [n lo hi] [to integer! min hi max lo n]
]

dot: func [v w] [
    (v/1 * w/1) + (v/2 * w/2) + (v/3 * w/3)
]
norm: func [v] [
    m: square-root dot v v
    reduce [v/1 / m  v/2 / m  v/3 / m]
]

print death-star [x: 20 y: 20 z: 0 r: 20][x: 10 y: 10 z: -15 r: 10] norm [-2 1 3] 2 0.1
