(define (FFR n)
	(+ (FFR (1- n)) (FFS (1- n))))
	
(define (FFS n)
	(define next (1+ (FFS (1- n))))
	(for ((k (in-naturals next)))
		  #:break (not (vector-search* k (cache 'FFR))) => k
		  ))
	
(remember 'FFR #(0 1)) ;; init cache
(remember 'FFS #(0 2))
