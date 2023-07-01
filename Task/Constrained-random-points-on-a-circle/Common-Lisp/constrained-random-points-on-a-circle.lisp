(flet ((good-p (x y) (<= 100 (+ (* x x) (* y y)) 255)))
  (loop with x with y with cnt = 0
	with scr = (loop repeat 31 collect (loop repeat 31 collect "  "))
	while (< cnt 100)
	do (when (good-p (- (setf x (random 31)) 15)
			 (- (setf y (random 31)) 15))
	     (setf (elt (elt scr y) x) "@ ")
	     (incf cnt))
	finally (mapc #'(lambda (row) (format t "~{~a~^~}~%" row)) scr)))
