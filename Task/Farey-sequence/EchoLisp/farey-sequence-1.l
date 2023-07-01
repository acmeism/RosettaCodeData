(define distinct-divisors
	(compose make-set prime-factors))
	
;; euler totient :  Φ :  n / product(p_i) * product (p_i - 1)
;; # of divisors <= n

(define (Φ n)
	(let ((pdiv (distinct-divisors n)))
	(/ (* n  (for/product ((p pdiv)) (1- p))) (for/product ((p pdiv)) p))))
	
;; farey-sequence length |Fn|  = 1 + sigma (m=1..) Φ(m)

(define ( F-length n) (1+ (for/sum ((m (1+ n))) (Φ m))))

;; farey sequence
;; apply the definition :  O(n^2)
(define (Farey N)
	(set! N (1+ N))
	(make-set (for*/list ((n N) (d (in-range n N))) (rational n d))))
