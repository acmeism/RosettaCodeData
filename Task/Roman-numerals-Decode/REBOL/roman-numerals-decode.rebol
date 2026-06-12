Rebol [
    title: "Rosetta code: Roman numerals/Decode"
    file:  %Roman_numerals-Decode.r3
    url:   https://rosettacode.org/wiki/Roman_numerals-Decode
]

roman-to-arabic: function/with [
    "Converts a Roman numeral string to its Arabic integer value; returns NONE on invalid input"
    roman [string!] "Roman numeral string (e.g. {XIV})"
][
    arabic: 0
    parse roman [
        some [
            copy roman: [
              #"I" [ #"V" | #"X" | none]
            | #"X" [ #"L" | #"C" | none]
            | #"C" [ #"D" | #"M" | none]
            | #"V" | #"L" | #"D" | #"M"
            ](
                arabic: arabic + table/:roman
            )
        ]
        end | (return none)
    ]
    arabic
][
    table: #[
        "I"  1  "IV" 4   "V"  5
        "IX" 9   "X" 10  "XL" 40  "L" 50
        "XC" 90  "C" 100 "CD" 400 "D" 500
        "CM" 900 "M" 1000
    ]
]

;; tests:
foreach roman [
    "XXXfoo"
    "XXXIII"
    "MDCCCLXXXVIII"
    "MMXVI"
][
    printf [-15 " -> "] [:roman roman-to-arabic :roman]
]
