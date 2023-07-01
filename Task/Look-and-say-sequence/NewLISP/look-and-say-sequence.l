;;;	Compute the following number in the sequence
(define (next-number s)
	(let (n 0 c (first s) res "")
		(dostring (x s)
			(if (= (char x) c)	; the iteration variable is the ASCII code
				(++ n)
				(begin
					(setq res (string res n c))
					(setq n 1 c (char x)))))
		(setq res (string res n c))
		res))
;
;;;	Print out the first n+1 numbers, starting from 1
(define (go n)
	(let (s "1")
		(println s)
		(dotimes (x n)
			(setq s (next-number s))
			(println s))))
;
(go 10)
