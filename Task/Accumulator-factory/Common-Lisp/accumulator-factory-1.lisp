(defun accumulator (sum)
  (lambda (n)
    (incf sum n)))
