(defun sum-3-5 (n)
  (apply '+ (seq-filter
	     '(lambda (x) (or (= 0 (% x 3) ) (= 0 (% x 5) )))
	     (number-sequence 1 (- n 1))) ))
