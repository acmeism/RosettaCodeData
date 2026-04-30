Rebol [
    title: "Rosetta code: Luhn test of credit card numbers"
    file:  %Luhn_test_of_credit_card_numbers.r3
    url:   https://rosettacode.org/wiki/Luhn_test_of_credit_card_numbers
]

luhn?: function [
    "Luhn algorithm validator - returns true/false if a number passes the Luhn check."
    "Used to validate credit card numbers and other identification numbers."
    num [integer! string!]
][
    sum: 0
    ;; Define a character set matching only numeric digits '0' through '9'
    digit: system/catalog/bitsets/numeric

    ;; Reverse the string so we process digits right-to-left, as Luhn requires.
    parse reverse form num [
        ;; SOME means "match the following pattern one or more times"
        some [
            ;; --- ODD position digits (1st, 3rd, 5th... from the right) ---
            set num: digit (
                ;; Convert char to integer by subtracting ASCII value of '0'
                ;; and add directly to sum (odd-position digits are unchanged)
                sum: sum + num - #"0"
            )
            ;; --- EVEN position digits (2nd, 4th, 6th... from the right) ---
            opt [set num: digit (
                ;; Double the digit (after converting char to integer)
                num: 2 * (num - #"0")
                ;; If doubling gives > 9, subtract 9 (equivalent to summing the
                ;; two digits of the result, e.g. 14 -> 1+4=5, same as 14-9=5)
                if num > 9 [num: num - 9]
                ;; Add the adjusted even-position digit to the running sum
                sum: sum + num
            )]
        ]
    ]
    ;; Return true if total sum is divisible by 10 (Luhn check passes)
    zero? sum % 10
]

foreach num [49927398716 49927398717 1234567812345678 1234567812345670][
    print [num 'is pick [valid invalid] luhn? num "number."]
]
