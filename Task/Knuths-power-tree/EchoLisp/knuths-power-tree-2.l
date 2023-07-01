;; j such  as chain[i] = chain[i-1] + chain[j]
(define (adder chain  i)
	(for ((j i)) #:break (= [chain i] (+ [chain(1-  i)] [chain j])) => j ))
		
		
(define (power-exp x chain)
	(define lg (vector-length chain))
	(define pow (make-vector lg x))
	(for ((i  (in-range 1 lg)))
	(vector-set! pow  i ( * [pow [1- i]] [pow (adder chain i)])))
	[pow (1- lg)])
