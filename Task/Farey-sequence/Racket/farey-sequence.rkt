#lang racket
(require math/number-theory)
(define (display-farey-sequence order show-fractions?)
  (define f-s (farey-sequence order))
  (printf "-- Farey Sequence for order ~a has ~a fractions~%" order (length f-s))
  ;; racket will simplify 0/1 and 1/1 to 0 and 1 respectively, so deconstruct into numerator and
  ;; denomimator (and take the opportunity to insert commas
  (when show-fractions?
    (displayln
     (string-join
      (for/list ((f f-s))
        (format "~a/~a" (numerator f) (denominator f)))
      ", "))))

; compute and show the Farey sequence for order:
;  1   through   11   (inclusive).
(for ((order (in-range 1 (add1 11)))) (display-farey-sequence order #t))
; compute and display the number of fractions in the Farey sequence for order:
;  100   through   1,000   (inclusive)   by hundreds.
(for ((order (in-range 100 (add1 1000) 100))) (display-farey-sequence order #f))
