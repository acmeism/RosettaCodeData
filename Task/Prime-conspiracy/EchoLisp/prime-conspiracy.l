(lib 'math) ;; (in-primes n) stream
(decimals 4)

(define (print-trans trans   m N)
(printf "%d first primes. Transitions prime %% %d → next-prime %% %d." N m m)
	(define s (// (apply + (vector->list trans)) 100))
	(for ((i (* m m)) (t trans))
	#:continue (<= t 1) ;; get rid of 2,5 primes
	(printf  " %d → %d   count: %10d frequency:   %d %%  "
              (quotient i m)  (% i m) t  (// t s) )))

;; can apply to any modulo m
;; (in-primes n) returns a stream of primes

(define (task (m  10) (N 1000_000))
	(define trans (make-vector (* m m)))
	(for ((p1 (in-primes 2)) (p2 (in-primes 3)) (k N))
		 (vector+= trans (+ (* (% p1 m) m) (% p2 m)) 1))
	(print-trans trans   m N))
