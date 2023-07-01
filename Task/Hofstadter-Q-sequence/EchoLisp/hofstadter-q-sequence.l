(define RECURSE_BUMP 500) ;; minimum of chrome:500 safari:1000 firefox:2000

;; count flips
(define (flips N)
	(for/sum ((n (in-range 2 (1+ N))))
	#:when (< (Q n) (Q (1- n)))  1))
		
(cache-size 120000)
(define (Q n)
	;; prevent browser stack overflow at low-cost
	(when (zero? (modulo n RECURSE_BUMP)) (for ((i (in-range 0 n RECURSE_BUMP ))) (Q i)))
	(+ (Q (- n (Q (1- n)))) (Q (- n (Q (- n 2))))))
(remember 'Q #(1 1 1)) ;; memoize and init


;; first call : check stack OK
(Q 100000) → 48157

(for ((i 11)) (write (Q i)))
1 1 1 2 3 3 4 5 5 6 6

(Q 1000)  → 502
(flips 100000) → 49798
