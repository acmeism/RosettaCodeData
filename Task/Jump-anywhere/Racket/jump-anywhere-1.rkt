#lang racket
(define (never-divides-by-zero return)
  (displayln "I'm here")
  (return "Leaving")
  (displayln "Never going to reach this")
  (/ 1 0))

(call/cc never-divides-by-zero)

;    outputs:
;        I'm here
;        "Leaving"    (because that's what the function returns)
