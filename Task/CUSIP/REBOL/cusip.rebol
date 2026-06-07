Rebol [
    title: "Rosetta code: CUSIP"
    file:  %CUSIP.r3
    url:   https://rosettacode.org/wiki/CUSIP
]

cusip?: function [
    "Validate a CUSIP number using its check digit."
    cusip [string!]
][
    if 9 != length? cusip [
        return false                              ;; CUSIP must be 9 characters
    ]

    sum: 0
    repeat i 8 [                                  ;; skip last (check) digit
        c: cusip/:i
        v: case [
            all [c >= #"0" c <= #"9"] [c - #"0"]  ;; numeric character
            c = #"*" [36]
            c = #"@" [37]
            c = #"#" [38]
            'else    [c - #"A" + 10]              ;; A=10, B=11, ...
        ]
        if even? i [v: v * 2]                     ;; double odd-position digits
        sum: sum + (v // 10) + (v % 10)           ;; sum the two decimal digits of v
    ]
    (#"0" + (10 - (sum % 10) % 10)) == last cusip
]

foreach cusip [
    "037833100" "17275R102" "38259P508"
    "594918104" "68389X106" "68389X105"
][
    print [as-green cusip "is" pick ["valid" "invalid"] cusip? cusip]
]
