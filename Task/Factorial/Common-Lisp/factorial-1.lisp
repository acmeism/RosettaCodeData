(defun factorial (n)
  (if (zerop n) 1 (* n (factorial (1- n)))))
