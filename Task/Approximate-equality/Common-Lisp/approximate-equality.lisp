(defun approx-equal (float1 float2 &optional (threshold 0.000001))
  "Determine whether float1 and float2 are equal; THRESHOLD is the
maximum allowable difference between normalized significands of floats
with the same exponent. The significands are scaled appropriately
before comparison for floats with different exponents."
  (multiple-value-bind (sig1 exp1 sign1) (decode-float float1)
    (multiple-value-bind (sig2 exp2 sign2) (decode-float float2)
      (let ((cmp1 (float-sign sign1 (scale-float sig1 (floor (- exp1 exp2) 2))))
            (cmp2 (float-sign sign2 (scale-float sig2 (floor (- exp2 exp1) 2)))))
        (< (abs (- cmp1 cmp2)) threshold)))))
