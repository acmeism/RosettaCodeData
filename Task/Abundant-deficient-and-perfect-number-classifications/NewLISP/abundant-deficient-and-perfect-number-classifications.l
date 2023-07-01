;;;	The list (1 .. n-1) of integers is generated
;;;	then each non-divisor of n is replaced by 0
;;;	finally all these numbers are summed.
;;;	fn defines an anonymous function inline.
(define (sum-divisors n)
	(apply + (map (fn (x) (if (> (% n x) 0) 0 x)) (sequence 1 (- n 1)))))
;
;;;	Returns the symbols -, p or + for deficient, perfect or abundant numbers respectively.
(define (number-type n)
	(let (sum (sum-divisors n))
		(if
			(< sum n)	'-
			(= sum n)	'p
			true		'+)))
;
;;;	Tallies the types from 2 to n.
(define (count-types n)
	(count '(- p +) (map number-type (sequence 2 n))))
;
;;;	Running:
(println (count-types 20000))
