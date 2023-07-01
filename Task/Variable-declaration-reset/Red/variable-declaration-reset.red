Red[]
s: [1 2 2 3 4 4 5]
repeat i length? s [
    curr: s/:i
    if all [i > 1 curr = prev][
        print i
    ]
    prev: curr
]
