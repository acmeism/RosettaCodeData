(defun horner (coeffs x)
  (reduce #'(lambda (coef acc) (+ (* acc x) coef))
	  coeffs :from-end t :initial-value 0))
