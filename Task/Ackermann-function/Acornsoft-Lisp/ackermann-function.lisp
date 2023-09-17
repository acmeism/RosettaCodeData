(defun ack (m n)
  (cond ((zerop m) (add1 n))
        ((zerop n) (ack (sub1 m) 1))
        (t         (ack (sub1 m) (ack m (sub1 n))))))
