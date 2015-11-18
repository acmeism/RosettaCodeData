(define (composites l q primes)
  (after q l
    (λ(t)
      (let ([p (car primes)] [r (cadr primes)])
        (composites (union t (ints-from q p))   ; q = p*p
                    (* r r) (cdr primes))))))
(define primes (cons 2
                 (diff (ints-from 3 1)
                       (composites (ints-from 4 2) 9 (cdr primes)))))
