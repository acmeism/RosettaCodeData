(defun accumulator (sum)
  (lambda (n)
    (setf sum (+ sum n))))
