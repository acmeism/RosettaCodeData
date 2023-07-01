(defun factorial (n)
  (if (< n 2) 1 (* n (factorial (1- n)))))
