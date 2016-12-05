;; implementation of Floyd algorithm to find cycles in a graph
;; see Wikipedia https://en.wikipedia.org/wiki/Cycle_detection
;; returns (cycle-length cycle-starter steps)
;; steps = 0 if no cycle found
;; it's all about a tortoise  🐢 running at speed f(x) after a hare 🐰 at speed f(f (x))
;; when they meet, a cycle is found

(define (floyd f x0 steps maxvalue)
	(define lam 1) ; cycle length
	(define tortoise (f x0))
	(define hare (f (f x0)))
	
	;; cyclic  ? yes if steps > 0
	(while (and (!= tortoise hare) (> steps 0))
		(set!-values (tortoise hare) (values (f tortoise) (f (f hare))))
		#:break (and (> hare maxvalue) (set! steps 0))
		(set! steps (1- steps)))
		
	;; first repetition = cycle starter
	(set! tortoise x0)
	(while (and (!= tortoise hare) (> steps 0))
		(set!-values (tortoise hare) (values (f tortoise) (f hare))))
		
	;; length of shortest cycle
	(set! hare (f tortoise))
	(while (and (!= tortoise hare) (> steps 0))
		(set! hare (f hare))
		(set! lam (1+ lam)))
	(values lam tortoise steps))
	
;; find cycle and classify
(define (taxonomy n (steps 16) (maxvalue 140737488355328))
	  (define-values (cycle starter steps) (floyd sum-divisors n steps maxvalue))
	 (write  n
	 (cond
	    (( = steps 0) 'non-terminating)
	    (( = starter 0) 'terminating)
	    ((and (= starter n) (= cycle 1)) 'perfect)
	    ((and (= starter n) (= cycle 2)) 'amicable)
            ((= starter n)  'sociable )
	    ((= cycle 1)  'aspiring )
	    (else 'cyclic)))
	
	(aliquote n starter)
	)
	
;; print sequence
(define (aliquote x0  (starter -1) (end -1 )(n 8))
  (for ((i n))
    (write x0)
    (set! x0 (sum-divisors x0))
    #:break (and (= x0 end) (write x0))
    (when (= x0 starter) (set! end starter)))
    (writeln ...))
