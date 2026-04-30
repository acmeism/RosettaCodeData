Rebol [
    title: "Rosetta code: Digital root"
    file:  %Digital_root.r3
    url:   https://rosettacode.org/wiki/Digital_root
    needs: 3.0.0
]
droot: function [
    "Calculate the digital root and additive persistence of a number"
    num   [integer!]
    return: [block!] "[persistence root]"
] [
    persistence: 0
    ;; Keep summing digits until we get a single digit
    until [
        ;; Convert number to string for digit processing
        str: form num
        num: 0
        ;; Iterate through each character in the string
        ;; Convert each digit character to its numeric value and sum
        forall str [ num: num + (str/1 - #"0") ]
        ;; Count how many iterations we've done
        ++ persistence
        ;; Stop when we reach a single digit (< 10)
        num < 10
    ]
    ;; Return both the persistence count and the final digital root
    reduce [persistence num]
]
;; Test the function with several numbers
foreach i [627615 39390 588225 393900588225 55] [
    a: droot i
    print [pad i -12 "has additive persistence" a/1 "and digital root of" a/2]
]
