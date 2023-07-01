;; copied from Scheme
(define (A k x1 x2 x3 x4 x5)
  (define (B)
    (set! k (- k 1))
    (A k B x1 x2 x3 x4))
  (if (<= k 0)
      (+ (x4) (x5))
      (B)))

(A 10 (lambda () 1) (lambda () -1) (lambda () -1) (lambda () 1) (lambda () 0))
   → -67
(A 13 (lambda () 1) (lambda () -1) (lambda () -1) (lambda () 1) (lambda () 0))
   → -642
(A 14 ..)
❗ InternalError : too much recursion - JS internal error (please, report it)-
   → stack overflow using FireFox
