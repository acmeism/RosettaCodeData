(require 'bigint)
;; test equality mod p
(define-syntax-rule (mod= a b p)
	 (zero?  (% (- a b) p)))
;; assign mod p
(define-syntax-rule (mod:≡ s v p)
	(set! s (% v p)))

(define (Legendre a p)
	 (powmod a (/ (1- p) 2) p))

(define (Tonelli n p)
    (unless (= 1 (Legendre n p)) (error "not a square (mod p)" (list n p)))
    (define q (1- p))
    (define s 0)
	(while (even? q)
		(/= q 2)
		(++ s))
	(if (= s 1) (powmod n (/ (1+ p) 4) p)
	(begin
	(define z
		(for ((z (in-range 2 p)))
		  #:break (= (1- p)  (Legendre z p)) => z ))

	(define c (powmod z q p))
	(define r (powmod n (/ (1+ q) 2) p))
	(define t (powmod n q p))
	(define m s)
	(define t2 0)
	(while #t
		#:break (mod= 1  t p) => r
		(mod:≡ t2 (* t t) p)
		(define i
			(for ((i (in-range 1 m)))
				#:break (mod= t2 1 p) => i
				(mod:≡ t2 (* t2 t2) p)))
		(define b (powmod c (expt 2 (- m i 1)) p))
		(mod:≡ r (* r b) p)
		(mod:≡ c (* b b) p)
		(mod:≡ t (* t c) p)
		(set! m i)))))
