Rebol [
    title: "Rosetta code: Achilles numbers"
    file:  %Achilles_numbers.r3
    url:   https://rosettacode.org/wiki/Achilles_numbers
]

phi: function [
    {Euler's totient function}
    n [integer!]
][
    result: n p: 2
    while [p * p <= n] [
        if zero? n % p [
            while [zero? n % p] [n: n // p]
            result: result - (result // p)
        ]
        ++ p
    ]
    if n > 1 [result: result - (result // n)]
    result
]

powerful?: function [
    {Check if n is a powerful number (all prime factors appear at least squared)}
    n [integer!]
][
    m: n p: 2
    while [p * p <= n] [
        if zero? m % p [
            exp: 0
            while [zero? m % p] [
                m: m // p
                ++ exp
            ]
            if exp < 2 [return false]
        ]
        ++ p
    ]
    m = 1
]

perfect-power?: function [
    {Check if n is a perfect power (n = r^k for some integers r,k >= 2)}
    n [integer!]
][
    k: 2
    while [k <= to integer! (log-2 n)] [
        root: n ** (1.0 / k)
        r: round root
        if (to integer! r ** k) = n [return true]
        ++ k
    ]
    false
]

achilles?: func [
    {Check if n is an Achilles number (powerful but not a perfect power)}
    n [integer!]
][
    all [powerful? n  not perfect-power? n]
]

achilles: make block! 50
strong:   make block! 50
digit-counts: #(uint32! [0 0 0 0 0 0 0])
for n 2 1000000 1 [
    if achilles? n [
        d: 1 + to integer! log-10 n
        digit-counts/:d: 1 + digit-counts/:d
        if 50 > length? achilles [
            append achilles n
        ]
        if all [50 > length? strong  achilles? phi n] [
            append strong n
        ]
    ]
]

print "First 50 Achilles numbers:"
probe new-line/skip achilles true 10
print ""

print "First 50 Strong Achilles numbers:"
probe new-line/skip strong true 10
print ""

for d 2 6 1 [
    print [
        "Achilles numbers with" d "digits:" digit-counts/:d
    ]
]
