LynchBell-number: function[
    "Find the largest Lynch-Bell number less than the limit"
    num [integer!] "Limit"
][
    ;; Limit num to a maximum value (digits 5 and 0 are ruled out)
    num: min num 98764321
    ;; Loop downward from num until a Lynch-Bell number is found
    while [num > 0] [
        num: num - 1                          ;; Decrease number and check
        str: form num                         ;; Convert number to string to examine digits
        if any [
            find str #"0"                     ;; Reject if digit '0' appears (digits must be nonzero)
            find str #"5"                     ;; Reject if digit '5' appears (excluded by definition)
            str !== unique str                ;; Reject if digits are not all unique
            ;; Check divisibility by each digit
            foreach chr str [
                if num % (chr - #"0") != 0 [  ;; If number not divisible by this digit
                    break/return true         ;; Reject and continue the outer loop early
                ]
            ]
        ][ continue ]                         ;; If any test fails, skip to next number
        ;; First number passing all tests is the Lynch-Bell number, return it
        return num
    ]
]

foreach limit [10 100 1'000 10'000 100'000 1'000'000 10'000'000 100'000'000] [
    print ["^/LynchBell-number for limit:" limit]
    time: delta-time [num: LynchBell-number limit]
    print ["Found number:" num "in time:" time]
    foreach chr form num [
        div: chr - #"0"
        print [num "/" div "=" num / div]
    ]
]
