; twice faster, testing only odd divisors
(define (prime? n)
  (if (< n 4) (> n 1)
      (and (odd? n)
	   (let loop ((k 3))
	     (or (> (* k k) n)
		 (and (positive? (remainder n k))
		      (loop (+ k 2))))))))
