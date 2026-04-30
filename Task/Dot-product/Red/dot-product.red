Red [ "Dot product - hinjolicious" ]

#include %mylib/pipe-map.red
#include %mylib/transpose-zip.Red

demo "Dot product" [
a: [1  3 -5]
b: [4 -2 -1]
(reduce [a b]) |> zip ==> [_m/1 * _m/2] |> sum |> probe ; 3
]
