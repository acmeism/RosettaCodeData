REBOL []

a: [1 3 -5]
b: [4 -2 -1]

dot-product: function [v1 v2] [sum] [
    if (length? v1) != (length? v2) [
        make error! "error: vector sizes must match"
    ]
    sum: 0
    repeat i length? v1 [
        sum: sum + ((pick v1 i) * (pick v2 i))
    ]
]

dot-product a b
