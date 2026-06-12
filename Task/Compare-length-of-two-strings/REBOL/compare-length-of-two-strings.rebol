Rebol [
    title: "Rosetta code: Compare length of two strings"
    file:  %Compare_length_of_two_strings.r3
    url:   https://rosettacode.org/wiki/Compare_length_of_two_strings
    needs: 3.22.0 ;; used new `str/length` instead of `length? str`
]

A: "I am string"
B: "I am string too"

lA: A/length
lB: B/length

print reword case [
    lA < lB ["String $A ($lA) is smaller than string $B ($lB)"]
    lA > lB ["String $A ($lA) is larger than string $B ($lB)" ]
    'else   ["String $A ($lA) and string $B ($lB) are of equal length"]
][ a: as-green mold a b: as-green mold b la: as-red la lb: as-red lb ]

sort-by-length: function/with [strs [block!] "(modified)"] [
    sort/compare strs :by-length
][  by-length: func [a b] [a/length < b/length] ]

print [
    "Sorted strings (by length):"
    mold sort-by-length ["abcd" "123456789" "abcdef" "1234567"]
]
