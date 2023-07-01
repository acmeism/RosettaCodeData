(defun gcd* (a b)
  (if (zerop b)
       a
      (gcd2 b (mod a b))))
