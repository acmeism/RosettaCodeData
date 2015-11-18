(defun sum-3-5 (ls)
  (apply '+ (mapcar
	     '(lambda (x) (if (or (= 0 (% x 3) ) (= 0 (% x 5) ))
			      x 0) )
			ls) ))
