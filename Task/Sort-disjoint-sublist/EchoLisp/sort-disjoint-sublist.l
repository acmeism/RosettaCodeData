(define (sort-disjoint values indices)
    (define sorted (list-sort <
    (for/list [(v values) (i (in-naturals))]
	#:when (member i indices)  v)))
	
    (for/list [(v values) (i (in-naturals))]
	(if (not (member i indices)) v
	(begin0
		(first sorted)
		(set! sorted (rest sorted))))))
		
(define (task)
	(sort-disjoint '[7 6 5 4 3 2 1 0] {6 1 7}))
	
(task)
    → (7 0 5 4 3 2 1 6)
