(defun bitwise-operations (a b)
	; rotate operations are not supported
	(print `(,a and ,b = ,(logand a b)))
	(print `(,a or ,b = ,(logior a b)))
	(print `(,a xor ,b = ,(logxor a b)))
	(print `(,a left shift by ,b = ,(lsh a b)))
	(print `(,a right shift by ,b = ,(lsh a (- b)))) ; negative second operand shifts right
	(print `(,a arithmetic right shift by ,b = ,(ash a (- b)))) )
