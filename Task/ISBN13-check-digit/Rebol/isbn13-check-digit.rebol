Rebol [
    title: "Rosetta code: ISBN13 check digit"
    file:  %ISBN13_check_digit.r3
    url:   https://rosettacode.org/wiki/ISBN13_check_digit
    needs: 3.15.0 ;; or something like that
]
valid-isbn13?: function/with [
    "Validate the check digit of an ISBN-13 code"
    value [any-string!]
][
    sum: 0
    parse value [
        6 [
            to numeric set n: skip (sum: sum + n - #"0")         ;; Add digit at odd index (weight 1)
            to numeric set n: skip (sum: sum + (3 * (n - #"0"))) ;; Add digit at even index (weight 3)
        ]
        to numeric set n: skip (sum: sum + n - #"0")             ;; Add the 13th digit (weight 1)
        opt [to numeric (return false)]                          ;; If not exactly 13 digits, abort as invalid
    ]
    zero? (sum % 10)                                             ;; Valid if weighted sum is divisible by 10
] system/catalog/bitsets                                         ;; Supply numeric bitset for parse (matches digits)


;; Check given examples
foreach [str] ["978-0596528126" "978-0596528120" "978-1788399081" "978-1788399083" "978-2-74839-908-0"] [
    print [pad str 18 "-"  valid-isbn13? str]
]
