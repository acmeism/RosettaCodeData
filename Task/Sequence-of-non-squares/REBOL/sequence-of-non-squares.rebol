Rebol [
    title: "Rosetta code: Sequence of non-squares"
    file:  %Sequence_of_non-squares.r3
    url:   https://rosettacode.org/wiki/Sequence_of_non-squares
]

non-square: func[n [integer!]][n + to integer! 0.5 + square-root n]
square?:    func[n [integer!]][zero?  fraction square-root n]

print "The first 22 non─square numbers:"
probe collect [repeat i 22 [keep non-square i]]

;; Validate, that there are no square numbers in the range.
prin "In range 1 to 1'000'000: "
valid?: true
repeat i 1'000'000 [
    if square? non-square i [ valid?: false break ]
]
print either valid? [
    "Ok. No square numbers found."
][  "Oops... Square found!"]
