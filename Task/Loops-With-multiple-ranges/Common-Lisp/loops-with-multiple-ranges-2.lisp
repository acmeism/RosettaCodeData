(let ((prod 1)
      (sum 0)
      (x 5)
      (y -5)
      (z -2)
      (one 1)
      (three 3)
      (seven 7))

  (flet ((loop-body (j)			; Set the loop function
	   (incf sum (abs j))
	   (if (and (< (abs prod) (expt 2 27))
		    (/= j 0))
	       (setf prod (* prod j)))))

    (dolist (lst `((,(- three) ,(expt 3 3) ,three)
		   (,(- seven) ,seven ,x)
		   (555 ,(- 550 y) -1)
		   (22 -28 ,(- three))
		   (1927 1939 1)
		   (,x ,y ,z)
		   (,(expt 11 x) ,(+ (expt 11 x) one) 1)))
      (do ((i (car lst) (incf i (caddr lst))))
	  ((if (plusp (caddr lst))
	       (> i (cadr lst))
	       (< i (cadr lst))))
	(loop-body i))))

  (format t "~&sum  = ~14<~:d~>" sum)
  (format t "~&prod = ~14<~:d~>" prod))
