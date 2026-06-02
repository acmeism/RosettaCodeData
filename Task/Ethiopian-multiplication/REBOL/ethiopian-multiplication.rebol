Rebol [
    title: "Rosetta code: Ethiopian multiplication"
    file:  %Ethiopian_multiplication.r3
    url:   https://rosettacode.org/wiki/Ethiopian_multiplication
]

halve:  function [n][n >> 1]
double: function [n][n << 1]

ethiopian-multiply: function [
    "Returns the product of two integers using Ethiopian multiplication, with a printed trace"
    a [integer!] "The multiplicand (column halved)"
    b [integer!] "The multiplier (column doubled)"
][
    result: 0
    while [a <> 0][
        prin pad a -7
        either odd? a [
            result: result + b
            print [as-green pad b -5 "(keep)"]
        ][  print pad b -5]
        a: halve  a
        b: double b
    ]
    print "-------------"
    print as-yellow pad result -12
    result
]

; Example: should print the layout shown for input 17 and 34
ethiopian-multiply 17 34
