(defun fib (n)
  (assert (>= n 0) nil "'~a' is a negative number" n)
  (funcall
   (alambda (n)
     (if (>= 1 n)
	 n
	 (+ (self (- n 1)) (self (- n 2)))))
   n))
