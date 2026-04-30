Rebol [
    title: "Rosetta code: Largest number divisible by its digits"
    file:  %Largest_number_divisible_by_its_digits.r3
    url:   https://rosettacode.org/wiki/Largest_number_divisible_by_its_digits
]
largest-LynchBell-number: function[
    "Find the largest base 10 integer whose digits are all different, and is evenly divisible by each of its individual digits"
][
    ;; Uses the insights from the Raku solution.
    ;; 504 is product of digits 9, 8, and 7, which are used as factors
    num: 504 * to integer! (9876432 / 504)   ;; Largest 7-digit multiple of 504 less than 9'876'432;
                                             ;; 504 is divisible by 7*8*9 (magic), ensuring candidate divisibility
    while [num > 0][
        num: num - 504                       ;; Step down multiples of 504
        str: form num                        ;; Convert current number to string for digit checks
        if any [
            find str #"0"                    ;; Reject if digit '0' present (digits must be non-zero)
            find str #"5"                    ;; Reject if digit '5' is present (excluded by definition)
            str !== unique str               ;; Reject if digits are not all unique
            foreach chr str [                ;; For each digit, verify divisibility
                if num % (chr - #"0") != 0 [ ;; Number must be divisible by each digit
                    break/return true        ;; If not divisible, reject and skip to next number
                ]
            ]
        ][ continue ]                        ;; Continue if any rejection condition met
        ;; If none of the rejection conditions matched, this is the largest Lynch-Bell number
        return num
    ]
]

time: delta-time [num: largest-LynchBell-number]
print ["Found number:" num "in time:" time]
foreach chr form num [
    div: chr - #"0"
    print [num "/" div "=" num / div]
]
