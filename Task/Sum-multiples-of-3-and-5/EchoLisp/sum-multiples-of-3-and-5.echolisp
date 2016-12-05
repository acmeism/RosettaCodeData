(lib 'math) ;; divides?
(lib 'sequences) ;; sum/when

(define (task n  (k 3)  (p 5 ))
	 (when (!= (gcd k p) 1) (error "expected coprimes" (list k p)))
		(-
	 	(+ (sum/mults n k) (sum/mults n p)) ;; add multiples of k , multiples of p
	 	(sum/mults n (* k p)))) ;; remove multiples of k * p

;; using sequences
;; sum of multiples of k < n

(define (sum/mults n k)
	(sum/when (rcurry divides? k) [1 .. n]))

(task 1000 3 5)
    → 233168

;; using simple arithmetic - 🎩 young Gauss formula
;; sum of multiples of k < n  =
;; k*m*(m+1)/2 where m = floor(n/k)
(lib 'bigint)

(define (sum/mults n k)
	(set! n (quotient (1- n) k))
	(/ (* k n (1+ n )) 2))

(task 1e20 3 5)
    → 2333333333333333333316666666666666666668

(task 1000 42 666)
    ❌ error: expected coprimes (42 666)
		
