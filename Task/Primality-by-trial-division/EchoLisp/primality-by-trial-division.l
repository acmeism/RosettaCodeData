(lib 'sequences)

;; Try divisors iff n = 2k + 1
(define (is-prime? p)
	(cond
	[(< p 2) #f]
	[(zero? (modulo p 2)) (= p 2)]
	[else
	(for/and ((d [3 5 .. (1+ (sqrt p))] ))  (!zero? (modulo p d)))]))

(filter is-prime? (range 1 100))
    → (2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97)

;; Improve performance , try divisors iff  n = 6k+1 or n = 6k+5
(define (is-prime? p)
	(cond
	[(< p 2) #f]
	[(zero? (modulo p 2)) (= p 2)]
	[(zero? (modulo p 3)) (= p 3)]
	[(zero? (modulo p 5)) (= p 5)]
	[else  ;; step 6 : try divisors 6n+1 or 6n+5
		(for ((d [7 13 .. (1+ (sqrt p))] ))
			#:break (zero? (modulo p d)) => #f
			#:break (zero? (modulo p (+ d 4))) => #f
			#t )]))
	
(filter is-prime? (range 1 100))
    → (2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97)
