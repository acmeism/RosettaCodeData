(defun fibonacci (n)
  (let ((a 0) (b 1) (c n))
    (loop for i from 2 to n do
	 (setq c (+ a b)
	       a b
	       b c))
    c))
