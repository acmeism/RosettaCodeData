;; ref :  http://research.cs.wisc.edu/techreports/1990/TR909.pdf
;; delta multiple of  sqrt(n)
;; segment is [left .. left+delta-1]


(define (segmented sieve left delta  (p 2) (first 0))
	(define segment (make-bit-vector-1 delta))
	(define right (+ left (1- delta)))
	 (define pmax (sqrt right))
	  (while p
	  #:break (> p pmax)
	 (set! first (+ left (modulo (- p (modulo left p)) p )))
			
 	(for   [(q (in-range first (1+ right) p))]
	(bit-vector-set! segment (- q left) #f))	
        (set! p (bit-vector-scan-1 sieve (1+ p))))
	segment)

(define (seg-range nmin delta)
    (s-range (segmented s-primes nmin delta) 0 delta nmin))


(seg-range 10_000_000_000 1000) ;; 15 milli-sec

    → (10000000019 10000000033 10000000061 10000000069 10000000097 10000000103 10000000121
       10000000141 10000000147 10000000207 10000000259 10000000277 10000000279 10000000319
       10000000343 10000000391 10000000403 10000000469 10000000501 10000000537 10000000583
       10000000589 10000000597 10000000601 10000000631 10000000643 10000000649 10000000667
       10000000679 10000000711 10000000723 10000000741 10000000753 10000000793 10000000799
       10000000807 10000000877 10000000883 10000000889 10000000949 10000000963 10000000991
       10000000993 10000000999)

;; 8 msec using the native (prime?) function
(for/list ((p (in-range 1_000_000_000 1_000_001_000))) #:when (prime? p) p)
