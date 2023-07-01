;;;	No built-in big integer exponentiation
(define (exp-big x n)
	(setq x (bigint x))
	(let (y 1L)
		(if (= n 0)
			1L
			(while (> n 1)
				(if (odd? n)
					(setq y (* x y)))
				(setq x (* x x) n (/ n 2)))
		(* x y))))
;
;;; task
(define (test)
	(local (res)
		;	drop the "L" at the end
		(setq res (0 (- (length res) 1) (string (exp-big 5 (exp-big 4 (exp-big 3 2))))))
		(println "The result has:  " (length res) " digits")
		(println "First 20 digits: " (0 20 res))
		(println "Last 20 digits:  " (-20 20 res))))
