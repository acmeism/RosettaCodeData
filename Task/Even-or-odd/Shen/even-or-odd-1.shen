(define even?
    0 -> true
    X -> (odd? (- X 1)))

(define odd?
    0 -> false
    X -> (even? (- X 1)))
