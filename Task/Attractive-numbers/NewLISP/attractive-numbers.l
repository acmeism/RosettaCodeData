(define (prime? n)
	(= (length (factor n)) 1))
(define (attractive? n)
	(prime? (length (factor n))))
;
(filter attractive? (sequence 2 120))
