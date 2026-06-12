Rebol [
    title: "Rosetta code: Kronecker product"
    file:  %Kronecker_product.r3
    url:   https://rosettacode.org/wiki/Kronecker_product
]

kronecker-product: function [
    "Kronecker product of two matrices represented as blocks of rows."
    m1 [block!]
    m2 [block!]
][
    count: length? m2
    new-line/all collect [
        foreach e m1 [
            counter: 1 check: 0
            while [check < count][
                keep/only collect [
                    foreach n1 e [
                        foreach n2 m2/:counter [keep n1 * n2]
                    ]
                ]
                ++ counter
                ++ check
            ]
        ]
    ] on
]

a1: [[1 2] [3 4]]
b1: [[0 5] [6 7]]
probe kronecker-product a1 b1

a2: [[0 1 0] [1 1 1] [0 1 0]]
b2: [[1 1 1 1] [ 1 0 0 1] [1 1 1 1]]
probe kronecker-product a2 b2
