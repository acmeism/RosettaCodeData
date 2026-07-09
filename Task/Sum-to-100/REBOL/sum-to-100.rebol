Rebol [
    title: "Rosetta code: Sum to 100"
    file:  %Sum_to_100.r3
    url:   https://rosettacode.org/wiki/Sum_to_100
]

nexpr: 13122  ;; 2 * 3^8 (number of possible expressions)

evaluate: function [
    "Evaluate encoded expression: digits 1-9 with +, -, or join operations"
    code [integer!]
][
    value: 0  number: 0  power: 1
    for k 9 1 -1 [
        number: power * k + number
        mod: code % 3
        case [
            mod = 0 [value: value + number  number: 0  power: 1]  ;; add
            mod = 1 [value: value - number  number: 0  power: 1]  ;; subtract
            mod = 2 [power: 10 * power]                           ;; join digits
        ]
        code: code // 3
    ]
    value
]

print-code: function [
    "Print the expression represented by code"
    code [integer!]
][
    a: 19683  b: 6561  s: clear ""
    for k 1 9 1 [
        temp: (code % a) // b
        case [
            temp = 0 [if k > 1 [append s #"+"]]  ;; add
            temp = 1 [append s #"-"]             ;; subtract
        ]
        a: b  b: b // 3
        append s form k
    ]
    print ["^-" evaluate code "=" s]
]

print as-yellow "Show all solutions that sum to 100:"
for i 0 nexpr - 1 1 [
    if 100 == evaluate i [print-code i]
]
print ""

print as-yellow "Show the sum that has the maximum number of solutions:"
counts: make map! []
for i 0 nexpr - 1 1 [
    test: evaluate i
    if test > 0 [
        counts/:test: 1 + any [counts/:test 0]
    ]
]
best: nbest: 0
foreach [val cnt] counts [
    if cnt > nbest [best: val  nbest: cnt]
]
print [as-green best "has" as-green nbest "solutions^/"]

print as-yellow "Show the lowest positive number that can't be expressed:"
for i 1 123456789 1 [
    unless counts/:i [print [as-green i lf] break]
]

print as-yellow "Show the ten highest numbers that can be expressed:"
vals: sort keys-of counts
limit: length? vals
loop 10 [
    best: vals/:limit
    for j 0 nexpr - 1 1 [
        if best == evaluate j [print-code j]
    ]
    limit: limit - 1
]
