 (define (sieve s)
	(let ((p (head s)))
	  (s-cons p
	          (sieve (s-diff s (from-By p p))))))
 (define primes (sieve (from-By 2 1)))
