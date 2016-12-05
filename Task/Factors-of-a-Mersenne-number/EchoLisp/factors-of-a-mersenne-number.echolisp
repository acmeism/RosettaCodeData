;; M = 2^P - 1 , P prime
;; look for a prime divisor q such as : q < √ M, q = 1 or 7 modulo 8, q = 1 + 2kP
;; q is divisor if (powmod 2 P q) = 1
;; m-divisor returns q or #f

(define  ( m-divisor P )
;; must limit the search as √ M may be HUGE
(define  maxprime  (min 1_000_000_000 (sqrt (expt 2 P))))
(for ((q (in-range 1 maxprime (* 2 P))))
	#:when (member (modulo q 8) '(1 7))
	#:when (prime? q)
	#:break (= 1 (powmod 2 P q)) => q
	#f ))

(m-divisor 929)
    → 13007
(m-divisor 4423)
    → #f

(lib 'bigint)
(prime? (1- (expt 2 4423))) ;; 2^4423 -1 is a Mersenne prime
    → #t
