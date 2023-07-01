#lang racket
(define (ways-to-make-change cents coins)
  (cond ((null? coins) 0)
        ((negative? cents) 0)
        ((zero? cents) 1)
        (else
         (+ (ways-to-make-change cents (cdr coins))
            (ways-to-make-change (- cents (car coins)) coins)))))

(ways-to-make-change 100 '(25 10 5 1)) ; -> 242
