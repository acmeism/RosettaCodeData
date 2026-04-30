Rebol [
    title: "Rosetta code: Anagrams/Deranged anagrams"
    file:  %Anagrams-Deranged_anagrams.r3
    url:   https://rosettacode.org/wiki/Anagrams-Deranged_anagrams
]
;; Find the longest deranged anagram pair from unixdict.txt
;; A deranged anagram: same multiset of letters, and no position has the same letter in both words.

;; Load or fetch the dictionary
unless exists? %unixdict.txt [
    write %unixdict.txt
    read https://raw.githubusercontent.com/thundergnat/rc-run/refs/heads/master/rc/resources/unixdict.txt
]

words: read/lines %unixdict.txt

;; Build anagram buckets keyed by sorted letters
buckets: make map! [] 25000
foreach w words [
    k: sort copy w
    either find buckets k [
        append buckets/:k w
    ][  put buckets k reduce [w] ]
]

;; Predicate: true if a and b are deranged (same length, no same letter at same index)
deranged?: func [a [string!] b [string!]] [
    repeat i length? a [
        if a/:i == b/:i [return false]
    ]
    true
]

best-a: best-b: none
best-len: 0

;; Search each bucket for deranged pairs, track the longest length
foreach [k vals] buckets [
    if 2 <= length? vals [
        ;; process only near-best lengths
        if best-len <= len: length? vals/1 [
            repeat i length? vals [
                a: vals/:i
                repeat j i - 1 [
                    b: vals/:j
                    if deranged? a b [
                        if best-len < len [
                            best-len: len
                            best-a: a
                            best-b: b
                        ]
                    ]
                ]
            ]
        ]
    ]
]

either all [best-a best-b][
    print rejoin ["Longest deranged anagram length: " best-len]
    print rejoin ["Pair: " best-a "  <->  " best-b]
][
    print "No deranged anagram pair found."
]
