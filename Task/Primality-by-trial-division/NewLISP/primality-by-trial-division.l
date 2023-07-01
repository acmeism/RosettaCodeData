; Here are some simpler functions to help us:

(define (divisible? larger-number smaller-number)
	(zero? (% larger-number smaller-number)))

(define (int-root number)
	(floor (sqrt number)))

(define (even-prime? number)
	(= number 2))

; Trial division for odd numbers

(define (find-odd-factor? odd-number)
	(catch
		(for (possible-factor 3 (int-root odd-number) 2)
			(if (divisible? odd-number possible-factor)
				(throw true)))))

(define (odd-prime? number)
	(and
		(odd? number)
		(or
			(= number 3)
			(and
				(> number 3)
				(not (find-odd-factor? number))))))

; Now for the final overall Boolean function.

(define (is-prime? possible-prime)
	(or
		(even-prime? possible-prime)
		(odd-prime? possible-prime)))

; Let's use this to actually find some prime numbers.

(println (filter is-prime? (sequence 1 100)))
(exit)
