Rebol [
    title: "Rosetta code: Gapful numbers"
    file:  %Gapful_numbers.r3
    url:   https://rosettacode.org/wiki/Gapful_numbers
    needs: 3.0.0
]

gapful-numbers: function[start count][
    collect [                   ;; Collect result values into a block
        num: start              ;; Start searching from given number
        took: 0                 ;; Counter of found gapful numbers
        while [took < count][   ;; Repeat until count gapful numbers have been found
            s: form num         ;; Convert current number to string form
            d: to integer! ajoin [first s last s]  ;; Form divisor by concatenating first and last digits
            if zero? num % d [  ;; Check if number is divisible by this divisor (gapful condition)
                keep num        ;; If yes, add number to collected results
                ++ took         ;; Increment found count
            ]
            ++ num              ;; Increment current number to test next candidate
        ]
    ]
]

;; Test various start/count pairs
foreach [start count][
    100 30
    1000000 15
    1000000000 10
    7123 25
][
    print ["First" count "gapful numbers starting from" start]
    probe new-line/skip gapful-numbers start count true 5
]
