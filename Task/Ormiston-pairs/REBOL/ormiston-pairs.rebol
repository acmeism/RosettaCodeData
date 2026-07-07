Rebol [
    title: "Rosetta code: Ormiston pairs"
    file:  %Ormiston_pairs.r3
    url:   https://rosettacode.org/wiki/Ormiston_pairs
]

next-prime: function [
    "Return the first prime greater than n."
    n [integer!]
][
    i: n + either odd? n [2][1]  ;; step by 2 to stay odd
    forever [
        if prime? i [return i]
        i: i + 2
    ]
]

anagrams?: function [
    "Return true if a and b contain the same digits in any order."
    a [integer!] b [integer!]
][
    (sort form a) = (sort form b)  ;; compare sorted digit strings
]

ormiston?: function [
    "Return true if n is prime and anagram of the next prime."
    n [integer!]
][
    all [prime? n  anagrams? n next-prime n]
]

print as-green "First 30 Ormiston pairs:"
n: 0
i: 2
until [
    if ormiston? i [
        prin ajoin ["[" pad i -5 SP pad next-prime i 5 "] "]
        ++ n
        if zero? n % 5 [print ""]  ;; 5 pairs per line
    ]
    ++ i
    n == 30
]

count: 0
repeat i 1000000 [if ormiston? i [++ count]]
print ["^/Ormiston pairs below 1'000'000:" as-green count]
