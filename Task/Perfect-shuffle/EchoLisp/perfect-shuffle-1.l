;; shuffler : a permutation vector which interleaves both halves of deck
(define (make-shuffler n)
	(let ((s (make-vector n)))
		(for ((i (in-range 0 n 2))) (vector-set! s i (/ i 2)))
		(for ((i (in-range 0 n 2))) (vector-set! s (1+ i) (+ (/ n 2) (vector-ref s i))))
	 s))
	
;; output : (n . # of shuffles needed to go back)
(define (magic-shuffle n)
		(when (odd? n) (error "magic-shuffle:odd input" n))
		(let [(deck (list->vector (iota n))) ;; (0 1 ... n-1)
			(dock (list->vector (iota n))) ;; keep trace or init deck
			(shuffler (make-shuffler n))]
		
		(cons n (1+
		(for/sum ((i Infinity)) ; (in-naturals missing  in EchoLisp v2.9)
			(vector-permute! deck shuffler) ;; permutes in place
		    #:break (eqv? deck dock) ;; compare to first
			1)))))
