Red[]

nth: function [n][
    d: n % 10
    dd: n % 100
    suffix: either any [ all [ dd > 3 dd < 20 ] d < 1 d > 4 1 = to-integer n / 10] [4] [d]
    rejoin [n pick ["st" "nd" "rd" "th"] suffix]
]

test: function [low high][
    repeat i high - low + 1 [
        prin [nth i + low - 1 ""]
    ]
    prin newline
]

test 0 25
test 250 265
test 1000 1025
