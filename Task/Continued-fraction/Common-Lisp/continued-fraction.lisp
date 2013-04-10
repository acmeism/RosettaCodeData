(defun estimate-continued-fraction (generator n)
  (let ((temp 0))
    (loop for n1 from n downto 1
       do (multiple-value-bind (a b)
	      (funcall generator n1)
	    (setf temp (/ b (+ a temp)))))
    (+ (funcall generator 0) temp)))

(format t "sqrt(2) = ~a~%" (coerce (estimate-continued-fraction
				    (lambda (n)
				      (values (if (> n 0) 2 1) 1)) 20)
				   'double-float))
(format t "napier's = ~a~%" (coerce (estimate-continued-fraction
				     (lambda (n)
				       (values (if (> n 0) n 2)
					       (if (> n 1) (1- n) 1))) 15)
				    'double-float))

(format t "pi = ~a~%" (coerce (estimate-continued-fraction
			       (lambda (n)
				 (values (if (> n 0) 6 3)
					 (* (1- (* 2 n))
					    (1- (* 2 n))))) 10000)
			      'double-float))
