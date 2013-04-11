(define (identity n)
  (letrec
      ((uvec
	(lambda (m i acc)
	  (if (= i n)
	      acc
	      (uvec m (+ i 1)
		    (cons (if (= i m) 1 0) acc)))))
       (idgen
	(lambda (i acc)
	  (if (= i n)
	      acc
	      (idgen (+ i 1)
		     (cons (uvec i 0 '()) acc))))))
       (idgen 0 '())))
