Red ["For loop with multiple ranges"]

->: make op! function [start end][
    res: copy []
    repeat n 1 + absolute to-integer end - start [
        append res start + either start > end [1 - n][n - 1]
    ]
]
by: make op! function [s w] [extract s absolute w]

for: function ['word ranges body][
    inp: copy []
    foreach c reduce ranges [append inp c]
    foreach i inp [set word i do body]
]

 prod:  1
  sum:  0
    x: +5
    y: -5
    z: -2
  one:  1
three:  3
seven:  7

for j [
    0 - three -> (3 ** 3)   by three
    0 - seven -> seven      by x
        555   -> (550 - y)
        22    -> -28        by (0 - three)
        1927  -> 1939
        x     -> y          by z
    11 ** x   -> (11 ** x + one)
] [
    sum: sum + absolute j;
    if all [(absolute prod) < power 2 27 j <> 0] [prod: prod * j]
]
print ["sum: " sum "^/prod:" prod]
