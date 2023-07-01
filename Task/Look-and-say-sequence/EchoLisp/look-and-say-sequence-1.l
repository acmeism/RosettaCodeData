(lib 'math) ;; for (number->list) = explode function
(lib 'list) ;; (group)

(define (next L)
	(for/fold (acc null) ((g (group L)))
		(append acc (list (length g) (first g)))))
		

(define (task n starter)
(for/fold (L (number->list starter)) ((i n))
	(writeln (list->string L))
	(next L)))
