Rebol [
    title: "Rosetta code: Return multiple values"
    file:  %Return_multiple_values.r3
    url:   https://rosettacode.org/wiki/Return_multiple_values
]

addsub: func [
    "Returns both the sum and difference of two numbers"
    x [number!]
    y [number!]
][
    reduce [x + y  x - y]
]

set [summ diff] addsub 33 12
print ["33 + 12 =" summ]
print ["33 - 12 =" diff]
