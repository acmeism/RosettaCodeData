(defun my-expt-rec (a b)
  (cond
    ((= b 0) 1)
    (t (* a (my-expt-rec a (- b 1))))))
