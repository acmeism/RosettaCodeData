;; using (sum-divisors) from math.lib

(lib 'math)
(define (amicable N)
(define n 0)
	(for/list ((m (in-range 2 N)))
		(set! n (sum-divisors m))
		#:continue (>= n (* 1.5 m))  ;; assume n/m < 1.5
		#:continue (<= n m) ;; prevent perfect numbers
		#:continue (!= (sum-divisors n) m)
		(cons m n)))

(amicable 20000)
    → ((220 . 284) (1184 . 1210) (2620 . 2924) (5020 . 5564) (6232 . 6368) (10744 . 10856) (12285 . 14595) (17296 . 18416))

(amicable 1_000_000) ;; 42 pairs
   → (... (802725 . 863835) (879712 . 901424) (898216 . 980984) (947835 . 1125765) (998104 . 1043096))
