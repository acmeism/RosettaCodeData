(defun sum-sq (nums)
  (lists:foldl
    (lambda (x acc)
      (+ acc (* x x)))
    0 nums))
