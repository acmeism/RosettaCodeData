Rebol []
a: [1 3 -5]
b: [4 -2 -1]

dot-product: func [v1 v2 /local len sum] [
    len: length? v1
    if len <> length? v2 [
        make error! "error: vector sizes must match"
    ]
    sum: 0
    repeat i len [
        sum: sum + (v1/:i * v2/:i)
    ]
]

dot-product a b
