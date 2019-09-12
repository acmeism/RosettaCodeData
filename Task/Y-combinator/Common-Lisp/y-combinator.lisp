(defun Y (f)
  ((lambda (g) (funcall g g))
   (lambda (g)
     (funcall f (lambda (&rest a)
		  (apply (funcall g g) a))))))

(defun fac (n)
  (funcall
   (Y (lambda (f)
       (lambda (n)
         (if (zerop n)
	   1
	   (* n (funcall f (1- n)))))))
   n))

(defun fib (n)
  (funcall
   (Y (lambda (f)
       (lambda (n a b)
         (if (< n 1)
           a
           (funcall f (1- n) b (+ a b))))))
   n 0 1))

? (mapcar #'fac '(1 2 3 4 5 6 7 8 9 10))
(1 2 6 24 120 720 5040 40320 362880 3628800))

? (mapcar #'fib '(1 2 3 4 5 6 7 8 9 10))
(1 1 2 3 5 8 13 21 34 55)
