(lib 'sequences)
(define (is-prime? p)
	(cond
	[(< p 2) #f]
	[(zero? (modulo p 2)) (= p 2)]
	[else
		(for/and ((d [3 5 .. (1+ (sqrt p))] ))  (!zero? (modulo p d)))]))

(is-prime? 101) → #t	
