;; utility : make a set of sets from a list
(define (make-set* s)
		(or (when (list? s) (make-set (map make-set* s))) s))
		
;; union of all sets which intersect - O(n^2)
(define (make-big ss)
(make-set
	(for/list ((u ss))
	(for/fold (big u) ((v ss)) #:when (set-intersect? big v)  (set-union big v)))))
	
;; remove sets which are subset of another one - O(n^2)
(define (remove-small ss)
	(for/list ((keep ss))
	#:when (for/and ((v ss))  #:continue (set-equal? keep v) (not (set-subset? v keep)))
	keep))
	
(define (consolidate ss) (make-set (remove-small (make-big ss))))

(define S (make-set* ' ((h i k) ( a b) ( b c) (c d) ( f g h))))
    → { { a b } { b c } { c d } { f g h } { h i k } }

(consolidate S)
    → { { a b c d } { f g h i k } }
	
