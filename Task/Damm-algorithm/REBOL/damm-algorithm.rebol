Rebol [
    title: "Rosetta code: Damm algorithm"
    file:  %Damm_algorithm.r3
    url:   https://rosettacode.org/wiki/Damm_algorithm
    needs: 3.22.0 ; used integer-divide op
]

damm-valid?: function/with [
    "Return true if digit sequence passes the Damm check."
    digits [integer! block!]
][
    unless block? digits [digits: to-digits digits]
    interim: 0
    foreach d digits [
        interim: pickz pickz table interim d
    ]
    zero? interim
][
    table: [
        [0 3 1 7 5 9 8 6 4 2]
        [7 0 9 2 1 5 4 8 6 3]
        [4 2 0 6 8 7 1 3 5 9]
        [1 7 5 0 9 8 3 4 2 6]
        [6 1 2 3 0 4 5 9 7 8]
        [3 6 7 4 2 0 9 5 8 1]
        [5 8 6 9 7 2 0 1 3 4]
        [8 9 4 5 3 6 2 0 1 7]
        [9 4 3 8 6 1 7 2 0 5]
        [2 5 8 1 4 3 6 7 9 0]
    ]
    to-digits: function [
        "Return the decimal digits of a non-negative integer as a block."
        n [integer!]
    ][
        digits: make block! 10
        until [
            insert digits n % 10
            zero? n: n // 10
        ]
        digits
    ]
]

check-data: function [
    "Print whether a digit sequence is valid or invalid."
    digits [integer! block!]
][
    print [
        "Sequence" as-yellow digits
        pick ["is valid." "is invalid."] damm-valid? digits
    ]
]

check-data 5724
check-data 5727
check-data [1 2 3 4 5 6 7 8 9 0 1 2 3 4 6 7 8 9 0 1]
check-data [1 2 3 4 5 6 7 8 9 0 1 2 3 4 6 7 8 9 0 8]
