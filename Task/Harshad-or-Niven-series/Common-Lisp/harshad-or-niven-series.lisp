(defun harshadp (n)
  (zerop (rem n (digit-sum n))))

(defun digit-sum (n &optional (a 0))
  (cond ((zerop n) a)
	(t (digit-sum (floor n 10) (+ a (rem n 10))))))

(defun list-harshad (n &optional (i 1) (lst nil))
  "list the first n Harshad numbers starting from i (default 1)"
  (cond ((= (length lst) n) (reverse lst))
	((harshadp i) (list-harshad n (+ i 1) (cons i lst)))
	(t (list-harshad n (+ i 1) lst))))
