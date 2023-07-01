(define (median L) ;; O(n log(n))
	(set! L (vector-sort! < (list->vector L)))
	(define dim (// (vector-length L) 2))
	(if (integer? dim)
		(// (+ [L dim] [L (1- dim)]) 2)
		[L (floor dim)]))

(median '( 3 4 5))
   → 4
(median '(6 5 4 3))
   → 4.5
(median (iota 10000))
   → 4999.5
(median (iota 10001))
   → 5000
