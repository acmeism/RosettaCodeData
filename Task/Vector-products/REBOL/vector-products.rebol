Rebol [
    title: "Rosetta code: Vector products"
    file:  %Vector_products.r3
    url:   https://rosettacode.org/wiki/Vector_products
    needs: 3.20.0
]

;; Version using struct! datatype.

•: make op! dot-product: func[a b][
    (a/x * b/x) + (a/y * b/y) + (a/z * b/z)
]
⨯: make op! cross-product: func[a b][
    make vec3! [
        (a/y * b/z) - (a/z * b/y)
        (a/z * b/x) - (a/x * b/z)
        (a/x * b/y) - (a/y * b/x)
    ]
]

register vec3!: #(struct! [x [i64!] y [i64!] z [i64!]])
a: make vec3! [ 3   4   5]
b: make vec3! [ 4   3   5]
c: make vec3! [-5 -12 -13]

form-vec: func[v][mold/flat values-of :v]

print ["A =" form-vec a]
print ["B =" form-vec b]
print ["C =" form-vec c]
print ["A • B ="          a • b ]
print ["A ⨯ B =" form-vec a ⨯ b ]
print ["A • (B ⨯ C) ="           a • (b ⨯ c) ]
print ["A ⨯ (B ⨯ C) =" form-vec (a ⨯ (b ⨯ c))]
