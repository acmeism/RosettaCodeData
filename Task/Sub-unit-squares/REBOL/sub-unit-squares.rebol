Rebol [
    title: "Rosetta code: Sub-unit squares"
    file: %Sub-unit_squarese.r3
    url: https://rosettacode.org/wiki/Sub-unit_squares
]
;; A "sub-unit square" is a perfect square where:
;;   1. No digit is 0 (since subtracting 1 would produce a -1 digit)
;;   2. Its last two digits are "36" (necessary condition — see note below)
;;   3. Subtracting 1 from every digit yields another perfect square

sub-unit-square?: function [
    "Return true if the number is a sub-unit square."
    num [integer!]
][
    ;; Convert the number to a mutable string of digit characters
    str: append clear "" num
    all [
        ;; Reject any number containing a 0 digit — subtracting 1 would be invalid
        not find str #"0"
        ;; Fast pre-filter: sub-unit squares must end in "36"
        ;; (only squares ending in 36 can produce a square when each digit is decremented)
        "36" == skip tail str -2
        ;; Decrement every digit character in-place by 1
        ;; (e.g. "149" becomes "038", which as an integer is 38)
        forall str [str/1: str/1 - 1]
        ;; Parse the modified string back into an integer
        num: to integer! str
        ;; Compute the integer square root of the decremented number
        sqr: to integer! square-root num
        ;; Confirm it is a perfect square (guards against floating-point rounding)
        sqr * sqr == num
    ]
]

;; Collect the first 10 sub-unit squares
sub-unit-squares: copy []
n: 1
while [10 > length? sub-unit-squares][
    num: n * n
    ;; Test the current square and collect it if it qualifies
    if sub-unit-square? num [ append sub-unit-squares num ]
    ;; Advance to the next integer so we test the next perfect square
    ++ n
]

print "The first 10 sub-unit squares:"
print sub-unit-squares
