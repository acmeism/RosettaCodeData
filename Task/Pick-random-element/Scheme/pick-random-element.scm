; for Chicken Scheme
(import (chicken random))

(define (pick_random x)
    (list-ref x (pseudo-random-integer (length x)))
    )
