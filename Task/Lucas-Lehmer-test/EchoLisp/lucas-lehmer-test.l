(require 'bigint)
(define (mersenne-prime? odd-prime: p)
	(define mp (1- (expt 2 p)))
	(define s #4)
	(for [(i (in-range 3 (1+ p)))]
		(set! s (% (- (* s s) 2) mp)))
	(when (zero? s) (printf "M%d" p)))
	
;; run it in the background
(require 'tasks)
(define LP (primes 10000)) ; list of candidate primes

(define (mp-task LP)
	(mersenne-prime? (first LP))
	(rest LP)) ;; return next state
	
(task-run (make-task mp-task LP))

→  M3 M5 M7 M13 M17 M19 M31 M61 M89 M107 M127 M521 M607 M1279 M2203 M2281
