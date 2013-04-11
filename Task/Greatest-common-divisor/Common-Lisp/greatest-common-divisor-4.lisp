(defun gcd2 (a b)
  (loop for x = a then y
        and y = b then (mod x y)
        until (zerop y)
        finally (return x)))
