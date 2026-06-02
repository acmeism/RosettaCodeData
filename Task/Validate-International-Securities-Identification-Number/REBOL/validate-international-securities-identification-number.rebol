Rebol [
    title: "Rosetta code: Validate International Securities Identification Number"
    file:  %Validate_International_Securities_Identification_Number.r3
    url:   https://rosettacode.org/wiki/Validate_International_Securities_Identification_Number
]

valid-isin?: function/with [
    "International Securities Identification Number (ISIN) validator."
    code [string!]
][
    ;; Format validation:
    unless parse code [2 alpha 9 alpha-numeric 1 numeric][ return false ]
    ;; Convert to number:
    str: clear ""
    foreach c code [
        append str case [
            c >= #"a" [-87 + c]
            c >= #"A" [-55 + c]
            'else [c]
        ]
    ]
    ;; Luhn validation:
    sum: 0
    parse reverse str [
        some [
            set num: numeric (
                sum: sum + num - #"0"
            )
            opt [set num: numeric (
                num: 2 * (num - #"0")
                if num > 9 [num: num - 9]
                sum: sum + num
            )]
        ]
    ]
    zero? sum % 10
] :system/catalog/bitsets

foreach [code expected] [
    "US0378331005"  #(true)
    "US0373831005"  #(false)  ; The transposition typo is caught by the checksum constraint.
    "U50378331005"  #(false)  ; The substitution typo is caught by the format constraint.
    "US03378331005" #(false)  ; The duplication typo is caught by the format constraint.
    "AU0000XVGZA3"  #(true)
    "AU0000VXGZA3"  #(true)   ; Unfortunately, not all transposition typos are caught by the checksum constraint.
    "FR0000988040"  #(true)
][
    print [code valid-isin? code]
]
