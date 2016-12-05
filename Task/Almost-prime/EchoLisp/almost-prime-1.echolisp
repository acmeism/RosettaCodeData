(define (almost-prime? p k)
	(= k (length (prime-factors p))))
	
(define (almost-primes k nmax)
	(take (filter (rcurry almost-prime? k) [2 ..]) nmax))
	
(define (task (kmax 6) (nmax 10))
	(for ((k [1 .. kmax]))
		(write 'k= k '|)
		(for-each write (almost-primes k nmax))
		(writeln)))
