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
            [
              "IIIX" (a: 7  ) | "IIX"  (a: 8  )  ; 8-7 exceptions
            | "XXXC" (a: 70 ) | "XXC"  (a: 80 )  ; 80-70 exceptions
            | "CCXM" (a: 700) | "CCM"  (a: 800)  ; 800-700 exceptions
            ; other exceptions
            | "IM"   (a: 999)
            | "IC"   (a: 99 )
            | "XM"   (a: 990)  ; debatable
            | "VC"   (a: 95 )  ; debatable
            ; normal rules
            | #"I" [ #"V" (a: 4  )| #"X" (a: 9  )| none (a: 1  )]
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
    "XIV"      ;= 14
    "CMI"      ;= 901
    "MCMXC"    ;= 1990
    "MDCLXVI"  ;= 1666
    "MMVIII"   ;= 2008
    "MMXIX"    ;= 2019
    "MMMCMXCV" ;= 3995
    ; not standard:
    "IIII"     ;= 4
    "IIXX"     ;= 18
    "MIC"      ;= 1099
    ; invalid:
    "XXfoo"    ;= none
][
    printf [-15 " -> "] [:roman roman-to-arabic :roman]
]
