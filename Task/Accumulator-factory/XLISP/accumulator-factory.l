(defun accumulator (x)
	(lambda (n)
		(setq x (+ n x))
		x ) )
