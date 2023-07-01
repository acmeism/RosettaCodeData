> (defun gcd
  "Get the greatest common divisor."
  ((a 0) a)
  ((a b) (gcd b (rem a b))))
