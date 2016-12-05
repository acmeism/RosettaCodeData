 (define (primes-To m)
   (define (sieve s)
	(let ((p (head s)))
	 (cond ((> (* p p) m) s)
	  (else (s-cons p
	          (sieve (s-diff (tail s) (from-By (* p p) p))))))))
   (sieve (from-By 2 1)))
