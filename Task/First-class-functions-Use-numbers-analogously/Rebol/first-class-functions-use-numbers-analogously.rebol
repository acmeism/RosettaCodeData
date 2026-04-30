Rebol [
    title: "Rosetta code: First-class functions/Use numbers analogously"
    file:  %First-class_functions-Use_numbers_analogously.r3
    url:   https://rosettacode.org/wiki/First-class_functions/Use_numbers_analogously
]

;; Numeric values and their inverses
x:  2.0    xi: 0.5
y:  4.0    yi: 0.25
z:  x + y  zi: 1 / (x + y)

;; Returns a function that multiplies its argument a by n and m,
;; printing the expression before returning the result.
;; closure (vs func) ensures n and m are captured by value in the returned func.
multiplier: closure [n m] [
    func [a] [
        prin [a "*" n "*" m "= "]
        a * n * m
    ]
]
;; Parallel lists: each number paired with its inverse by position
num-list:     reduce [x  y  z]    ; [2.0  4.0  6.0]
num-list-inv: reduce [xi yi zi]   ; [0.5  0.25  0.1666...]

repeat key length? num-list [
    n:   num-list/:key
    ni:  num-list-inv/:key
    fun: multiplier ni n   ;; build closure: a * ni * n = a * 1.0 (always)
    print as-green fun 0.5 ;; call closure with 0.5; result should always be 0.5
]
