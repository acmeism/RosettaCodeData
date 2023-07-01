(lib 'math) ;; for bernoulli numbers
(string-delimiter "")

;; returns list of polynomial coefficients
(define (Faulhaber p)
	(cons 0
	(for/list ([k (in-range p -1 -1)])
		(* (Cnp (1+ p) k) (bernoulli k)))))

;; prints formal polynomial
(define (task (pmax 10))
    (for ((p pmax))
    (writeln p '→  (/ 1 (1+ p)) '* (poly->string 'n (Faulhaber p)))))

;; extra credit - compute sums
(define (Faulcomp n p)
	(printf "Σ(1..%d) n^%d = %d" n p (/  (poly n (Faulhaber p)) (1+ p) )))
