(defun greatest-common-divisor (x y)
	(if (= y 0)
		x
		(greatest-common-divisor y (mod x y)) ) )
