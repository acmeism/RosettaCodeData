Red [ "Vector products - hinjolicious" ]

#include %mylib/pipe-map.red
#include %mylib/transpose-zip.Red

vec-dot: function [a b][(reduce [a b]) |> zip ==> [_m/1 * _m/2] |> sum]
vec-x: function [a b][reduce [((a/2 * b/3) - (a/3 * b/2))  ((a/3 * b/1) - (a/1 * b/3))  ((a/1 * b/2) - (a/2 * b/1))]]
vec-dot-x: function [a b c][vec-dot a vec-x b c]
vec-x-x: function [a b c][vec-x a vec-x b c]

demo "Dot product" [
a: [ 3   4   5]
b: [ 4   3   5]
c: [-5 -12 -13]
]
demo "A • B = a1b1  + a2b2 + a3b3" [probe vec-dot a b]
demo "A x B = (a2b3 - a3b2, a3b1 - a1b3, a1b2 - a2b1)" [probe vec-x a b]
demo "A • (B x C)" [probe vec-dot-x a b c]
demo "A x (B x C)" [probe vec-x-x a b c]
