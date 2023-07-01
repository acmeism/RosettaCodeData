Red["Ethiopian multiplication"]

halve: function [n][n >> 1]
double: function [n][n << 1]
;== even? already exists

ethiopian-multiply: function [
    "Returns the product of two integers using Ethiopian multiplication"
    a [integer!] "The multiplicand"
    b [integer!] "The multiplier"
][
    result: 0
    while [a <> 0][
        if odd? a [result: result + b]
        a: halve a
        b: double b
    ]
    result
]

print ethiopian-multiply 17 34
