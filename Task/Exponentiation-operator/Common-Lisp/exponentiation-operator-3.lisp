(defun ^ (a b)
  (do ((x 1 (* x a))
       (y 0 (+ y 1)))
      ((= y b) x)))
