(defun gcd (a b)
    (cond
     ((< a b) (gcd a (- b a)))
     ((> a b) (gcd (- a b) b))
     (t a)))
