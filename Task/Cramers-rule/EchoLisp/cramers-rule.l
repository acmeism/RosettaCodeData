(lib 'matrix)
(string-delimiter "")
(define (cramer A B (X)) ;; --> vector X
	(define ∆ (determinant A))
	(for/vector [(i (matrix-col-num A))]
		(set! X (matrix-set-col! (array-copy A) i B))
		(// (determinant X) ∆)))
		
(define (task)
	(define A (list->array
  	'( 2 -1 5 1 3 2 2 -6 1 3 3 -1 5 -2 -3 3) 4 4))
	(define B #(-3 -32 -47 49))
	(writeln "Solving A * X = B")
	(array-print A)
	(writeln "B = " B)
	(writeln "X = " (cramer A B)))
