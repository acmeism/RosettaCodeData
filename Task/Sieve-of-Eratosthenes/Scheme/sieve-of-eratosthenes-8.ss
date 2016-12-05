 (define (sieve s)
	(let ((p (head s)))
	  (s-cons p
	          (sieve (s-diff (tail s) (from-By (+ p p) p))))))
 (define primes (sieve (from-By 2 1)))
