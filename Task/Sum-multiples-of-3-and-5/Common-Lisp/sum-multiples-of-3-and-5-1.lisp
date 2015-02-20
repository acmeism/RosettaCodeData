(defun sum-3-5-slow (limit)
  (loop for x below limit
        when (or (zerop (rem x 3)) (zerop (rem x 5)))
          sum x))
