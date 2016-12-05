(define -∏*2 (complex 0 (* -2 PI)))

(define (fft xs N)
	(if (<= N 1) xs
	(let* [
		(N/2 (/ N 2))
		(even (fft (for/vector ([i (in-range 0 N 2)]) [xs i]) N/2))
		(odd  (fft (for/vector ([i (in-range 1 N 2)]) [xs i]) N/2))
		]
	(for ((k N/2)) (vector*= odd k  (exp (/ (* -∏*2 k) N ))))
	(vector-append (vector-map + even odd) (vector-map - even odd)))))
	
(define data #( 1 1 1 1  0 0 0 0 ))

(fft data 8)
    → #( 4+0i 1-2.414213562373095i 0+0i 1-0.4142135623730949i
       0+0i 1+0.4142135623730949i 0+0i 1+2.414213562373095i)
