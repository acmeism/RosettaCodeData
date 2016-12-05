(require 'bigint)

;; factor-exp returns a list ((p k) ..) : a = p1^k1 * p2^k2 ..
(define (factor-exp a)
	(map (lambda (g) (list (first g) (length g)))
					(group* (prime-factors a))))

;; copied from Ruby
(define (_mult_order a p k  (x))
	(define pk (expt p k))
	(define t (* (1- p) (expt p (1- k))))
	(define r 1)
	(for [((q e) (factor-exp t))]
	    (set! x (powmod a (/ t (expt q e)) pk))
	    (while (!= x 1)
	    	(*= r q)
	    	(set! x (powmod x q pk))))
	r)
	
(define (order a m)
        "multiplicative order : (order a m) →  n : a^n = 1 (mod m)"
	(assert (= 1 (gcd a m)) "a and m must be coprimes")
	(define mopks (for/list [((p k)  (factor-exp m))] (_mult_order a p k)))
	(for/fold (n 1) ((mopk mopks)) (lcm n mopk)))

;; results
order 37 1000)
   → 100
(order (+ (expt 10 100) 1) 7919)
   → 3959
(order (+ (expt 10 1000) 1) 15485863)
   → 15485862
