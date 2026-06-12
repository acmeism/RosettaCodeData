(defparameter *epsilon* (sqrt 0.0000001d0))

(defun myfun (x y)
  (+  (* (- x 1)
	 (- x 1)
	 (exp (- (expt y 2))))
      (* y (+ 2 y)
	 (exp (- (* 2 (expt x 2)))))))

(defun xd (x y)
  (/ (-  (myfun (* x (+ 1 *epsilon*)) y)
	 (myfun (* x (- 1 *epsilon*)) y))
     (* 2 x *epsilon*)))

(defun yd (x y)
  (/ (-  (myfun x (* y (+ 1 *epsilon*)))
	 (myfun x (* y (- 1 *epsilon*))))
     (* 2 y *epsilon*)))

(defun gd ()
  (let ((x 0.1d0)
	(y -1.0d0))
    (dotimes (i 31)
      (setf xtemp (- x  (* 0.3d0 (xd x y))))
      (setf ytemp (- y   (* 0.3d0 (yd x y ))))
      (setf x xtemp)
      (setf y ytemp))
    (list x y)))



