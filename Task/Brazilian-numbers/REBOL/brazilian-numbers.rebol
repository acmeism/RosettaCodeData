Rebol [
    title: "Rosetta code: Brazilian numbers"
    file:  %Brazilian_numbers.r3
    url:   https://rosettacode.org/wiki/Brazilian_numbers
]

brazilian?: function [
    "Returns TRUE if n is a Brazilian number (repunit in some base 2..n-2)"
    n [integer!]
][
    case [
        n < 7       [return false]
        zero? n & 1 [return true ]             ;; all even n >= 8 are Brazilian
    ]
    for b 2 n - 2 1 [
        d: n digits: clear []
        while [d > 0][
            append digits d % b                ;; collect digits in base b
            d: d // b                          ;; integer division
        ]
        if single? unique digits [return true] ;; all digits same = repunit
    ]
    false
]

print-first-by-rule: function [
    "Prints the first 20 Brazilian numbers filtered by a stepping rule"
    rule  [block!]  "Block that advances i to the next candidate"
    title [string!] "Label inserted into the header line"
][
    print ajoin ["First 20 " title "Brazilian numbers:"]
    i: 7
    bind rule 'i  ;; bind rule's i to this function's context
    found: copy []
    while [20 > length? found][
        if brazilian? i [append found i]
        do rule
    ]
    probe found
    print ""
]

print-first-by-rule [i: i + 1] ""
print-first-by-rule [i: i + 2] "odd "
print-first-by-rule [i: i + 2  while [not prime? i] [i: i + 2]] "prime "
