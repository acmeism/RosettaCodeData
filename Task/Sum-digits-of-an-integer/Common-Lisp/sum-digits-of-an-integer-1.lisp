(defun sum-digits (number base)
  (loop for n = number then q
        for (q r) = (multiple-value-list (truncate n base))
        sum r until (zerop q)))
