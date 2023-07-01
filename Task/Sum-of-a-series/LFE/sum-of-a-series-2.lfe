(defun sum-series (nums)
  (lists:sum
    (lists:map
      (lambda (x) (/ 1 x x))
      nums)))
