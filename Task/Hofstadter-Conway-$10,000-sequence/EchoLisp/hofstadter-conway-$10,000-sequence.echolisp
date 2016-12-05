(decimals 4)
(cache-size 2000000)

(define (a n)
	(+ (a (a (1- n))) (a (- n (a (1- n))))))
	
(remember 'a #(0 1 1)) ;; memoize

;; prints max a(n)/n in [2**i 2**i+1] intervals
;; return Mallows number checked up to 2**20
(define (task  (maxv) (start 1) (end 2) (v) (mrange 0))
	(for ((i  (in-range 1 21)))
	(set! maxv 0)
	
	(for ((n  (in-range start end)))
	(set! v (// (a n) n))
	#:when (> v maxv)
		(set! maxv v))
	    (when (and (zero? mrange) (< maxv 0.55)) (set! mrange end))
	
	(printf "[%d .. %d]  →  max a(n)/n:  %d " start end maxv)
	(set! start end)
	(set! end (* start 2)))
	
;; mallows
	(for ((n (in-range mrange 2 -1)))
		#:break (> (// (a n) n) 0.55) => n )
	)
