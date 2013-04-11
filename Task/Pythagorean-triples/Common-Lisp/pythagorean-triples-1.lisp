(defun mmul (a b)
  (loop for x in a collect
	(loop for y in x
	      for z in b sum (* y z))))

(defun count-tri (lim)
  (let ((prim 0) (cnt 0))
    (labels ((count1 (tr)
      (let ((peri (reduce #'+ tr)))
	(when (<= peri lim)
	  (incf prim)
	  (incf cnt (truncate lim peri))
	  (count1 (mmul '(( 1 -2 2) ( 2 -1 2) ( 2 -2 3)) tr))
	  (count1 (mmul '(( 1  2 2) ( 2  1 2) ( 2  2 3)) tr))
	  (count1 (mmul '((-1  2 2) (-2  1 2) (-2  2 3)) tr))))))
      (count1 '(3 4 5))
      (format t "~a: ~a prim, ~a all~%" lim prim cnt))))

(loop for p from 2 do (count-tri (expt 10 p)))
