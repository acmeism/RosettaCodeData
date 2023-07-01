(set 'upper-bound 1000)

; The initial sieve is a list of all the numbers starting at 2.
(set 'sieve (sequence 2 upper-bound))

; Keep working until the list is empty.
(while sieve

	; The first number in the list is always prime
	(set 'new-prime (sieve 0))
	(println new-prime)

	; Filter the list leaving only the non-multiples of each number.
	(set 'sieve
		(filter
			(lambda (each-number)
				(not (zero? (% each-number new-prime))))
			sieve)))

(exit)
