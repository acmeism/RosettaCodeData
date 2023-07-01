(lib 'math) ;; sum-divisors function

(define-syntax-rule (++ a) (set! a (1+ a)))

(define (abondance (N 20000))
    (define-values (delta abondant deficient perfect) '(0 0 0 0))
    (for ((n (in-range 1 (1+ N))))
	 (set! delta (- (sum-divisors n) n))
	 (cond
	 	((< delta 0) (++ deficient))
	 	((> delta 0) (++ abondant))
	 	(else (writeln 'perfect→ n) (++ perfect))))
	 	
	(printf "In range 1.. %d" N)
	(for-each (lambda(x) (writeln x (eval x))) '(abondant deficient perfect)))

(abondance)
    perfect→     6
    perfect→     28
    perfect→     496
    perfect→     8128
    In range 1.. 20000
    abondant     4953
    deficient     15043
    perfect     4
