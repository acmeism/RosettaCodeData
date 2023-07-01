;; Finding perfect numbers
(define (sum/inv n) ;; look for div's in [2..sqrt(n)] and add 1/n
	(for/fold (acc (/ n)) [(i (in-range 2 (sqrt n)))]
		#:break (> acc 1) ; no hope
		(when (zero? (modulo n i ))
			(set! acc (+ acc (/ i) (/ i n))))))
