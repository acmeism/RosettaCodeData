(lib 'list) ;; list-delete

;; let n = product p_i^a_i , p_i prime
;; number of divisors = product (a_i + 1) - 1
(define (numdivs n)
    (1- (apply * (map (lambda(g) (1+ (length g))) (group (prime-factors n))))))

(remember 'numdivs)
	
;; prime powers
;; input : a list g of grouped prime factors ( 3 3 3 ..)
;; returns (1 3 9 27 ...)
(define (ppows g (mult 1))
	(for/fold (ppows '(1)) ((a g))
	(set! mult (* mult a))
	(cons mult ppows)))

;; proper divisors
;; decomp n into ((2 2 ..) ( 3 3 ..)  ) prime factors groups
;; combines (1 2 4 8 ..) (1 3 9 ..) lists
;; remove n from the list

(define (divs n)
   (if (<= n 1) null
    (list-delete
        (for/fold (divs'(1)) ((g (map  ppows (group (prime-factors n)))))
		    (for*/list ((a divs) (b g)) (* a b)))
    n )))

;; find number(s) with max # of proper divisors
;; returns list of (n . maxdivs)  for n in range 2..N

(define (most-proper N)
    (define maxdivs 1)
    (define ndivs 0)
    (for/fold (most-proper null) ((n (in-range 2 N)))
       (set! ndivs (numdivs n))
        #:continue (< ndivs maxdivs)
        (when (> ndivs maxdivs)
        (set!-values (most-proper maxdivs) (values null ndivs)))
        (cons (cons n maxdivs) most-proper)))
