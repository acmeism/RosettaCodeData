Rebol [
    title: "Rosetta code: Lychrel numbers"
    file:  %Lychrel_numbers.r3
    url:   https://rosettacode.org/wiki/Lychrel_numbers
]

big-add: function [
    "Big integer addition using strings"
    a [string!] b [string!]
][
    ;; Ensure we're working on independent copies so we don't mutate the originals
    a: append clear "" a
    b: append clear "" b

    ;; Left-pad the shorter number with zeros so both strings are the same length
    n: (length? a) - length? b
    insert/dup either n < 0 [a][b] #"0" absolute n

    result: copy ""
    c: 0  ; carry digit
    ;; Walk digits right-to-left, summing each column and propagating carry
    for i length? a 1 -1 [
        d: (a/:i - #"0") + (b/:i - #"0") + c  ;; numeric value of column sum
        c: d / 10                             ;; carry into next column
        insert result (#"0" + (d % 10))       ;; prepend the ones digit to result
    ]
    ;; If a final carry remains, prepend it (e.g. 999 + 1 = 1000)
    if #"0" != c: #"0" + c [insert result c]
    result
]

lychrel: function/with [
    "Determine whether an integer is a Lychrel number candidate"
    ;; Returns the Lychrel seed: the lowest related number in the chain,
    ;; or none if num resolves to a palindrome within 1000 steps (i.e. not Lychrel).
    ;; Results are memoised in the `cache` map shared across all calls.
    num [integer!]
][
    ;; Return cached result immediately if this number was seen before
    if val: cache/:num [return val]

    ns:  to string! num      ;; current value as string (grows with each iteration)
    rv:  reverse copy ns     ;; its digit-reversal
    res: num                 ;; default: num is its own seed
    seen: clear []           ;; numbers encountered during this chain, not yet cached

    loop 1000 [
        ns: big-add ns rv    ;; next value = current + reverse
        rv: reverse copy ns  ;; reverse of the new value

        ;; Palindrome found -> num is NOT a Lychrel number
        if ns == rv [ res: none break ]

        ;; Hit a number whose Lychrel status is already known -> inherit its result
        if val: cache/:ns [ res: val break ]

        append seen ns     ;; record this intermediate value for bulk caching below
    ]

    ;; Backfill the cache for every intermediate number encountered in this chain
    foreach x seen [cache/:x: res]
    res
][
    ;; local context - cache persists across calls
    cache: make map! []

]

seeds:   copy []  ;; Lychrel seeds:   numbers that are their own chain origin
related: copy []  ;; Lychrel related: numbers that lead to a known Lychrel seed
palin:   copy []  ;; Lychrel palindromes: Lychrel numbers that are also palindromes
;; Run the search over the first 10 000 positive integers and time it
repeat num 10000 [
    s: lychrel num  ;; none = not Lychrel, otherwise the seed of num's chain
    if s [
        ;; Seeds are numbers equal to their own chain origin; others are related
        append either num == s [seeds][related] num
        ;; Check whether num is also a palindrome in its own right
        if (to string! num) == reverse to string! num [append palin num]
    ]
]
print [as-green pad length? seeds   -6 "Lychrel seeds:" as-yellow seeds]
print [as-green pad length? related -6 "Lychrel related"]
print [as-green pad length? palin   -6 "Lychrel palindromes:" as-yellow palin]
