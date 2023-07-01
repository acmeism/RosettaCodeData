#lang racket
;; Positive version from "popcount_4" in:
;;   https://en.wikipedia.org/wiki/Hamming_weight#Efficient_implementation
;; negative version follows R6RS definition documented in:
;;   http://docs.racket-lang.org/r6rs/r6rs-lib-std/r6rs-lib-Z-H-12.html?q=bitwise-bit#node_idx_1074
(define (population-count n)
  (if (negative? n)
      (bitwise-not (population-count (bitwise-not n)))
      (let inr ((x n) (rv 0))
        (if (= x 0) rv (inr (bitwise-and x (sub1 x)) (add1 rv))))))

(define (evil? x)
  (and (not (negative? x))
       (even? (population-count x))))

(define (odious? x)
  (and (positive? x)
       (odd? (population-count x))))

(define tasks
  (list
   "display the pop count of the 1st thirty powers of 3 (3^0, 3^1, 3^2, 3^3, 3^4, ...)."
   (for/list ((i (in-range 30))) (population-count (expt 3 i)))
   "display the 1st thirty evil numbers."
   (for/list ((_ (in-range 30)) (e (sequence-filter evil? (in-naturals)))) e)
   "display the 1st thirty odious numbers."
   (for/list ((_ (in-range 30)) (o (sequence-filter odious? (in-naturals)))) o)))

(for-each displayln tasks)

(module+ test
  (require rackunit)
  (check-equal?
   (for/list ((p (sequence-map population-count (in-range 16)))) p)
   '(0 1 1 2 1 2 2 3 1 2 2 3 2 3 3 4))
  (check-true (evil? 0) "0 has just *got* to be evil")
  (check-true (evil? #b011011011) "six bits... truly evil")
  (check-false (evil? #b1011011011) "seven bits, that's odd!")
  (check-true (odious? 1) "the least odious number")
  (check-true (odious? #b1011011011) "seven (which is odd) bits")
  (check-false (odious? #b011011011) "six bits... is evil"))
