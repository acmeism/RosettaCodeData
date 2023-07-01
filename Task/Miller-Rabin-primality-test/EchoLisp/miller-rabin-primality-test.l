(lib 'bigint)

;; output : #t if n probably prime
(define (miller-rabin n (k 7) (composite #f)(x))
(define d (1- n))
(define s 0)
(define a 0)
(while (even? d)
	(set! s (1+ s))
	(set! d (quotient d 2)))

(for [(i k)]
	(set! a (+ 2 (random (- n 3))))
	(set! x (powmod a d n))
	#:continue (or (= x 1) (= x (1- n)))
	(set! composite
	(for [(r (in-range 1 s))]
		(set! x (powmod x 2 n))
		#:break (= x 1) => #t
		#:break (= x (1- n)) =>  #f
		#t
		))
	 #:break composite => #f )
 (not composite))

;; output
(miller-rabin #101)
    → #t
(miller-rabin #111)
    → #f
(define big-prime (random-prime 1e+100))
3461396142610375479080862553800503306376298093021233334170610435506057862777898396429
6627816219192601527
(miller-rabin big-prime)
    → #t
(miller-rabin (1+ (factorial 100)))
    → #f
(prime? (1+ (factorial 100))) ;; native
    → #f
