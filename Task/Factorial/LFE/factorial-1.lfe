(defun factorial (n)
  (cond
    ((== n 0) 1)
    ((> n 0) (* n (factorial (- n 1))))))
