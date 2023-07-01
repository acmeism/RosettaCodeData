(define dim 250)

;; speed up n^5
(define (p5 n) (* n n n n n))
(remember 'p5) ;; memoize

;; build vector of all  y^5 - x^5 diffs - length 30877
(define all-y^5-x^5
	(for*/vector
		[(x (in-range 1 dim))  (y (in-range (1+ x) dim))]
		(- (p5 y) (p5 x))))
		
;; sort to use vector-search
(begin (vector-sort! <  all-y^5-x^5) 'sorted)

 ;; find couple (x y) from y^5 - x^5
(define (x-y y^5-x^5)
	(for*/fold (x-y null)
	[(x (in-range 1 dim)) (y (in-range (1+ x ) dim))]
		(when
			(= (- (p5 y) (p5 x)) y^5-x^5)
			(set! x-y (list x y))
			(break #t)))) ; stop on first

;; search
(for*/fold  (sol null)
	[(x0 (in-range 1 dim)) (x1 (in-range (1+ x0) dim)) (x2 (in-range (1+ x1) dim))]
	(set! sol (+ (p5 x0) (p5 x1) (p5 x2)))
 	(when
 		(vector-search sol all-y^5-x^5)  ;; x0^5 + x1^5 + x2^5 = y^5 - x3^5 ???
 		(set! sol (append (list x0 x1 x2) (x-y  sol))) ;; found
 		(break #t))) ;; stop on first

  →   (27 84 110 133 144) ;; time 2.8 sec
 		
