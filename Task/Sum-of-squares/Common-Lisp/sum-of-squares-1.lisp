(defun sum-of-squares (vector)
  (loop for x across vector sum (expt x 2)))
