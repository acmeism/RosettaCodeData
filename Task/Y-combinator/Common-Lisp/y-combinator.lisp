(defun Y (f)
  ((lambda (x) (funcall x x))
   (lambda (y)
     (funcall f (lambda (&rest args)
		  (apply (funcall y y) args))))))

(defun fac (f)
  (lambda (n)
    (if (zerop n)
	1
	(* n (funcall f (1- n))))))

(defun fib (f)
  (lambda (n)
    (case n
      (0 0)
      (1 1)
      (otherwise (+ (funcall f (- n 1))
		    (funcall f (- n 2)))))))

? (mapcar (Y #'fac) '(1 2 3 4 5 6 7 8 9 10))
(1 2 6 24 120 720 5040 40320 362880 3628800))

? (mapcar (Y #'fib) '(1 2 3 4 5 6 7 8 9 10))
(1 1 2 3 5 8 13 21 34 55)
