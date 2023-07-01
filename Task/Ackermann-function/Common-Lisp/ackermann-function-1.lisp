(defun ackermann (m n)
  (cond ((zerop m) (1+ n))
        ((zerop n) (ackermann (1- m) 1))
        (t         (ackermann (1- m) (ackermann m (1- n))))))
