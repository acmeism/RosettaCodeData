(defun quadratic (a b c)
  "Compute the roots of a quadratic in the form ax^2 + bx + c = 1.  Evaluates to a list of the two roots."
  (let ((discriminant (- (expt b 2) (* 4 a c)))
        (denominator (* 2 a))
        (neg-b (* b -1)))
    (list (/ (+ neg-b (sqrt discriminant)) denominator)
     (/ (- neg-b (sqrt discriminant)) denominator))))
