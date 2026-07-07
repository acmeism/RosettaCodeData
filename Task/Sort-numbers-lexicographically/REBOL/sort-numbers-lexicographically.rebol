Rebol [
    title: "Rosetta code: Sort numbers lexicographically"
    file:  %Sort_numbers_lexicographically.r3
    url:   https://rosettacode.org/wiki/Sort_numbers_lexicographically
]

;; Initialize numbers
n: 13 numbers: copy []
repeat i n [append numbers i]
print ["Array before sort:" mold numbers]

;; Sort numbers lexicographically
sort/compare numbers func[a b][(form a) < (form b)]
print ["Array after  sort:" mold numbers]
