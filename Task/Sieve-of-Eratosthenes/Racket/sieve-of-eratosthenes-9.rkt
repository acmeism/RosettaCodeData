(define (composites l q primes)
  (after q l (λ(t) (let ([p (car primes)] [r (cadr primes)])
    (composites (union t (ints-from q (* 2 p))) ; q = p*p
                (* r r) (cdr primes))))))
(define primes (cons 2 (cons 3 (diff (ints-from 5 2)
                 (composites (ints-from 9 6) 25 (cddr primes))))))
