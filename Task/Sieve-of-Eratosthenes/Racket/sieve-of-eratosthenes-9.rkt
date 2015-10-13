(define primes
  (cons 2 (diff (ints-from 3 1)
                (foldr (λ(p r) (define q (* p p))
                               (cons q (union (ints-from (+ q p) p) r)))
                       '() primes))))
