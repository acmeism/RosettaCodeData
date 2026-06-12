Rebol [
    title: "Rosetta code: Roman numerals/Decode"
    file:  %Roman_numerals-Decode.r3
    url:   https://rosettacode.org/wiki/Roman_numerals-Decode
]

roman-to-arabic: function [
    "Converts a Roman numeral string to its Arabic integer value; returns NONE on invalid input"
    roman [string!] "Roman numeral string (e.g. {XIV})"
][
    arabic: 0
    parse roman [
        some [
            copy roman: [
              #"I" [ #"V" (a: 4  )| #"X" (a: 9  )| none (a: 1  )]
            | #"X" [ #"L" (a: 40 )| #"C" (a: 90 )| none (a: 10 )]
            | #"C" [ #"D" (a: 400)| #"M" (a: 900)| none (a: 100)]
            | #"V" (a: 5)
            | #"L" (a: 50)
            | #"D" (a: 500)
            | #"M" (a: 1000)
            ](
                arabic: arabic + a
            )
        ]
        end | (return none)
    ]
    arabic
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
