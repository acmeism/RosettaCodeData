(defun integer-sequence-from (x)
	(print x)
	(integer-sequence-from (+ x 1)) )

(integer-sequence-from 1)
