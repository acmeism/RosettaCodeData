(lib 'list) ;; for list-delete

(define dataM
'((the cat sat on the mat)
(the cat sat on the mat)
(A B C A B C A B C)
(A B C A B D A B E)
(A B)
(A B)
(A B B A)))
		
(define orderM
'((mat cat)
(cat mat)
(C A C A)
(E A D A)
(B)
(B A)
(B A)))

(define (order-disjoint M N)
(define R (append N null)) ;; tmp copy of N : delete w when used
	(for/list [(w M)]
	(if
		(not (member w R)) w ;; output as is
		(begin0
		(first N) ;; replacer
		(set! N (rest N))
		(set! R (list-delete R w))))))
		
