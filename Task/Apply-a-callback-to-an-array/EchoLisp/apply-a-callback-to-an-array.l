(vector-map sqrt #(0 4 16 49))
    → #( 0 2 4 7)
;; or
(map exp #(0 1 2))
    → #( 1 2.718281828459045 7.38905609893065)
;; or
(for/vector ([elem #(2 3 4)] [i (in-naturals)]) (printf "v[%d] = %a" i elem) (* elem elem))
v[0] = 2
v[1] = 3
v[2] = 4
    → #( 4 9 16)
