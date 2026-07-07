Rebol [
    title: "Rosetta code: Smallest numbers"
    file:  %Smallest_numbers.r3
    url:   https://rosettacode.org/wiki/Smallest_numbers
]

bigpow: function [
    "Returns base to the power of exp as an arbitrary-precision string"
    base [integer!]
    exp  [integer!]
] [
    digits: copy [1]                   ;; LSB-first digit array, starts at 1
    loop exp [
        carry: 0
        repeat i length? digits [
            tmp: digits/:i * base + carry
            digits/:i: tmp % 10        ;; store ones digit
            carry: tmp // 10           ;; propagate to next
        ]
        while [carry > 0] [
            append digits carry % 10   ;; extend array if needed
            carry: carry // 10
        ]
    ]
    result: copy ""
    for i (length? digits) 1 -1 [
        append result #"0" + digits/:i ;; MSB-first into string
    ]
    result
]

result: make map! []  ;; n -> smallest k where k^k contains n

k: 1
while [51 > length? result] [
    pow-str: bigpow k k
    for n 0 50 1 [
        unless find result n [         ;; skip already found
            if find pow-str form n [   ;; n appears in k^k?
                put result n k
            ]
        ]
    ]
    ++ k
]

for n 0 50 1 [ prin [result/:n ""] ]
print ""
