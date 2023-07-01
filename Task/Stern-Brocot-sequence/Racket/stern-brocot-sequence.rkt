#lang racket
;; OEIS Definition
;; A002487
;;   Stern's diatomic series
;;   (or Stern-Brocot sequence):
;;     a(0) = 0, a(1) = 1;
;;     for n > 0:
;;       a(2*n) = a(n),
;;       a(2*n+1) = a(n) + a(n+1).
(define A002487
  (let ((memo (make-hash '((0 . 0) (1 . 1)))))
    (lambda (n)
      (hash-ref! memo n
                 (lambda ()
                   (define n/2 (quotient n 2))
                   (+ (A002487 n/2) (if (even? n) 0 (A002487 (add1 n/2)))))))))

(define Stern-Brocot A002487)

(displayln "Show the first fifteen members of the sequence.
(This should be: 1, 1, 2, 1, 3, 2, 3, 1, 4, 3, 5, 2, 5, 3, 4)")
(for/list ((i (in-range 1 (add1 15)))) (Stern-Brocot i))

(displayln "Show the (1-based) index of where the numbers 1-to-10 first appears in the sequence.")
(for ((n (in-range 1 (add1 10))))
  (for/first ((i (in-naturals 1))
              #:when (= n (Stern-Brocot i)))
    (printf "~a first found at a(~a)~%" n i)))

(displayln "Show the (1-based) index of where the number 100 first appears in the sequence.")
(for/first ((i (in-naturals 1)) #:when (= 100 (Stern-Brocot i))) i)

(displayln "Check that the greatest common divisor of all the two consecutive members of the
series up to the 1000th member, is always one.")
(unless
    (for/first ((i (in-range 1 1000))
                #:unless (= 1 (gcd (Stern-Brocot i) (Stern-Brocot (add1 i))))) #t)
  (display "\tdidn't find gcd > (or otherwise ≠) 1"))
