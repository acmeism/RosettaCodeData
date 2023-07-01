;; ppows
;; input : a list g of grouped prime factors ( 3 3 3 ..)
;; returns (1 3 9 27 ...)

(define (ppows g (mult 1))
	(for/fold (ppows '(1)) ((a g))
	    (set! mult (* mult a))
	    (cons mult ppows)))

;; factors
;; decomp n into ((2 2 ..) ( 3 3 ..)  ) prime factors groups
;; combines (1 2 4 8 ..) (1 3 9 ..) lists

(define (factors n)
   (list-sort <
   (if (<= n 1) '(1)
        (for/fold (divs'(1)) ((g (map  ppows (group (prime-factors n)))))
		    (for*/list ((a divs) (b g)) (* a b))))))
