(defun gcd2 (a b)
  (if (zerop b) a
      (gcd2 b (mod a b))))
