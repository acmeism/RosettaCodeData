Rebol [
    title: "Rosetta code: Kronecker product based fractals"
    file:  %Kronecker_product_based_fractals.r3
    url:   https://rosettacode.org/wiki/Kronecker_product_based_fractals
]

kronecker: context [
    product: function [
        "Kronecker product of two matrices"
        m1 m2
    ][
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
                    ++ counter
                    ++ check
                ]
            ]
        ]
    ]

    iterate: function [
        "Apply Kronecker product n times"
        matrix [block!] n [integer!]
    ][
        result: matrix
        loop n - 1 [result: product result matrix]
        result
    ]

    render: function [
        "Render the fractal"
        iterations [integer!]
        spec [block! map!]
    ][
        assert [
            block? matrix: spec/matrix
            tuple? color:  spec/color
        ]
        size:  to integer! 3 ** iterations

        matrix: iterate matrix iterations

        rows:  length? matrix
        cols:  length? matrix/1
        scale: to integer! size / cols

        img: make image! reduce [as-pair size size 0.0.0.0] ;; transparent image

        repeat y rows [
            repeat x cols [
                cm: matrix/:y/:x * color ;; mix color with color with fractional values
                if cm/4 > 0 [            ;; not transparent
                    ;; Draw a filled square or gradual color
                    sy: (y - 1) * scale
                    sx: (x - 1) * scale
                    repeat dy scale [
                        repeat dx scale [
                            pos: (sy + dy - 1) * size + sx + dx
                            if all [pos > 0 pos <= (size * size)][ img/:pos: cm ]
                        ]
                    ]
                ]
            ]
        ]
        img
    ]
]

blend-images: func [
    "Blend images together"
    images [block!] size [pair!]
][
    result: make image! reduce [size black]

    foreach img images [
        repeat i (size/x * size/x) [
            px: img/:i
            if px/4 > 0 [  ;; If not transparent
                c: result/:i
                ;; Simple additive blend with alpha
                c/1: min 255 (c/1 + (px/1 * px/4 / 255))
                c/2: min 255 (c/2 + (px/2 * px/4 / 255))
                c/3: min 255 (c/3 + (px/3 * px/4 / 255))
                result/:i: c
            ]
        ]
    ]
    result
]

generate: function [
    "Generate the fractal"
    iterations
    patterns
][
    layers: copy []
    foreach p patterns [
        append layers img: kronecker/render iterations p
    ]
    blend-images layers img/size
]

img: generate 6 [
    ;; Vicsek
    [   matrix: [[0 1 0]
                 [1 1 1]
                 [0 1 0]]
        color: 255.0.0.255
    ]
    ;; Sierpinski carpet
    [   matrix: [[1 1 1]
                 [1 0 1]
                 [1 1 1]]
        color: 0.0.255.128
    ]
]

try [browse save %Kronecker_product_based_fractals.png img]
