(define (integers n)
  (lambda ()
    (let ((ans n))
      (set! n (+ n 1))
      ans)))

(define natural-numbers (integers 0))

(define (remove-multiples g n)
  (letrec ((m (+ n n))
           (self
              (lambda ()
                 (let loop ((x (g)))
                    (cond ((< x m) x)
                          ((= x m) (set! m (+ m n)) (self))
                          (else (set! m (+ m n)) (loop x)))))))
     self))

(define (sieve g)
  (lambda ()
    (let ((x (g)))
      (set! g (remove-multiples g x))
      x)))

(define primes (sieve (integers 2)))
