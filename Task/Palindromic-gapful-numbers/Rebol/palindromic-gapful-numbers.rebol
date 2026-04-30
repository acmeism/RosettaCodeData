Rebol [
    title: "Rosetta code: Palindromic gapful numbers"
    file:  %Palindromic_gapful_numbers.r3
    url:    https://rosettacode.org/wiki/Palindromic_gapful_numbers
    note:  "Based on Go language solution"
    needs:  3.0.0
]

palindromic-gapful-numbers: function/with [data [block!]][
    max: 100000                                   ;; Maximum number of palindromic gapful numbers to find
    max-digits: 10
    max-to-find: 0
    p: 0                                          ;; Current palindrome being tested
    results: make map! 12000                      ;; Map to store results: index -> [d1 d2 d3 ... d9]
    foreach d data [                              ;; Initialize result rows for requested indices
        for i d/1 d/2 1 [
            results/(to integer! i): copy [0 0 0 0 0 0 0 0 0] ;; Each row has 9 slots for digits 1-9
            max-to-find: max-to-find + 9
        ]
    ]
    ;; For each ending digit d = 1..9, generate palindromes and collect those divisible by d*11
    repeat d 9 [
        count: 0                                  ;; Count of valid palindromes found for digit d
        pow: 1                                    ;; Power of 10 for constructing palindromes
        divisor: d * 11                           ;; Divisor: d repeated (11, 22, 33, ..., 99)
        done?: false                              ;; Flag to break out of nested loops

        for nd 3 max-digits 1 [                   ;; Test palindromes of 3 to max-digits
            slim: (d + 1) * pow                   ;; Upper limit for left half generation
            for s d * pow slim - 1 1 [            ;; Generate left half starting with digit d
                e: rev10 s                        ;; Reverse s to create right half
                mlim: pick [9 0] odd? nd          ;; Middle digit limit: 0-9 for odd length, none for even
                for m 0 mlim 1 [                  ;; Iterate middle digit (if odd length)
                    p: either even? nd [
                        (s * pow * 10) + e        ;; Even length: concatenate left + right
                    ][
                        (s * pow * 100) + (m * pow * 10) + e  ;; Odd length: left + middle + right
                    ]
                    if zero? p % divisor [        ;; Check if palindrome is divisible by d*11 (gapful)
                        count: count + 1          ;; Increment count for this digit
                        row: select results count ;; Get result row for this position
                        if block? row [
                            poke row d p          ;; Store palindrome in column d
                            prin [clear-screen max-to-find mold row]
                            ;; Stop if we've found enough
                            -- max-to-find
                            if zero? max-to-find [done?: true break]
                        ]
                    ]
                ]
                if done? [break]                  ;; Break out of s loop
            ]
            if odd? nd [pow: pow * 10]            ;; Increase power for next digit length
            if done? [break]                      ;; Break out of nd loop
        ]
    ]
    prin clear-screen
    results
][
    clear-screen: "^[[H^[[2J^[[3J"
    ;; Helper function: Reverse the base-10 digits of a positive integer
    rev10: function [s [integer!]] [
        e: 0
        while [s > 0] [
            e: e * 10 + mod s 10   ;; Build reversed number digit by digit
            s: to integer! s / 10  ;; Remove last digit from s
        ]
        e
    ]
]

print palindromic-gapful-numbers [1x20 86x100 991x1000]
