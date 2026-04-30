Rebol [
    title: "Rosetta code: Fibonacci sequence"
    file:  %Fibonacci_sequence.r3
    url:   https://rosettacode.org/wiki/Fibonacci_sequence
]

fibonacci: function/with [
    {Return the Nth Fibonacci number using iterative state advancement.
    Uses a shared block to swap fn and fn-1 in a single expression.}
    number [integer!]  "which Fibonacci number to compute (0-indexed)"
][
    fn-1: 0                                    ;; F(0)
    fn:   1                                    ;; F(1)
    loop number advance-fibonacci
][
    fn: fn-1: 0
    advance-fibonacci: [ fn: fn-1 + fn-1: fn ] ;; simultaneously: new fn = old fn + old fn-1
]

probe collect [repeat i 18 [keep fibonacci i]]
