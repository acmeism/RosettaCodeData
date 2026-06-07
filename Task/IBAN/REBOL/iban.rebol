Rebol [
    title: "Rosetta code: IBAN"
    file:  %IBAN.r3
    url:   https://rosettacode.org/wiki/IBAN
]

valid-iban?: function/with [
    "Validate an IBAN number"
    iban [string!]
][
    ;; Remove whitespace and uppercase
    iban: uppercase trim/all copy iban

    ;; Ensure upper alphanumeric input
    unless parse iban [some valid-chars] [return false]

    ;; Validate country code against expected length
    cc: copy/part iban 2
    if lengths/:cc != length? iban [return false]

    ;; Shift: move first 4 chars to end
    append iban take/part iban 4

    ;; Convert each char: digits stay, letters become base-36 values
    digits: clear ""
    foreach c iban [
        append digits either c >= #"A" [c - #"A" + 10][ c ]
    ]
    ;; Compute mod-97 via chunking (avoids big-integer issues)
    remainder: 0
    foreach c digits [
        remainder: mod ((remainder * 10) + c - #"0") 97
    ]
    remainder = 1
][
    lengths: #[ ;https://www.iban.com/structure
        "AL" 28 "AD" 24 "AT" 20 "AZ" 28 "BH" 22
        "BY" 28 "BE" 16 "BA" 20 "BR" 29 "BG" 22
        "BI" 27 "CR" 22 "HR" 21 "CY" 28 "CZ" 24
        "DK" 18 "DJ" 27 "DO" 28 "EG" 29 "SV" 28
        "EE" 20 "FK" 18 "FO" 18 "FI" 18 "FR" 27
        "GE" 22 "DE" 22 "GI" 23 "GR" 27 "GL" 18
        "GT" 28 "HN" 28 "HU" 28 "IS" 26 "IQ" 23
        "IE" 22 "IL" 23 "IT" 27 "JO" 30 "KZ" 20
        "XK" 20 "KW" 30 "LV" 21 "LB" 28 "LY" 25
        "LI" 21 "LT" 20 "LU" 20 "MT" 31 "MR" 27
        "MU" 30 "MD" 24 "MC" 27 "MN" 20 "ME" 22
        "NL" 18 "NI" 28 "MK" 19 "NO" 15 "PK" 24
        "PS" 29 "PL" 28 "PT" 25 "QA" 29 "RO" 24
        "RU" 33 "LC" 32 "SM" 27 "ST" 25 "SA" 24
        "RS" 22 "SC" 31 "SK" 24 "SI" 19 "SO" 23
        "ES" 24 "VA" 22 "SD" 18 "OM" 23 "SE" 24
        "CH" 21 "TL" 23 "TN" 24 "TR" 26 "UA" 29
        "AE" 23 "GB" 22 "VG" 24 "YE" 30
    ]
    valid-chars: charset [#"A" - #"Z" #"0" - #"9"]

]

foreach test [
    "GB82 WEST 1234 5698 7654 32"
    "GB82 TEST 1234 5698 7654 32"
    "IE64 IRCE 9205 0112 3456 78"
    "BI13 20001 10001 00001234567 89"
][
    printf [32 /green 6 /reset][test valid-iban? test]
]
