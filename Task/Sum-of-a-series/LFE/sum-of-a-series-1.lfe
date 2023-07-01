(defun sum-series (nums)
  (lists:foldl
    #'+/2
    0
    (lists:map
      (lambda (x) (/ 1 x x))
      nums)))
