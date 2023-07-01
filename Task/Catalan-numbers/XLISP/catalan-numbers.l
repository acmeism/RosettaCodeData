(defun catalan (n)
	(if (= n 0)
		1
		(* (/ (* 2 (- (* 2 n) 1)) (+ n 1)) (catalan (- n 1))) ) )

(defun range (x y)
	(cons x
		(if (< x y)
			(range (+ x 1) y) ) ) )

(print (mapcar catalan (range 0 14)))
