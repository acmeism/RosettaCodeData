(defun sum-3-5 (ls)
  (apply '+ (seq-filter
	     '(lambda (x) (or (= 0 (% x 3) ) (= 0 (% x 5) )))
	     ls) ))
