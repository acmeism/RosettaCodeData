(defun factorial (n &optional (m 1))
  (if (zerop n) m (factorial (1- n) (* m n))))
