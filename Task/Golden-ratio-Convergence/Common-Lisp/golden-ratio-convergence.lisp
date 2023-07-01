(defun iterate (phi n)
  ;; This is a tail recursive definition, copied from the
  ;; Scheme. Common Lisp does not guarantee proper tail calls, but the
  ;; depth of recursion will not be too great.
  (let ((phi1 (1+ (/ phi)))
        (n1 (1+ n)))
    (if (<= (abs (- phi1 phi)) 1/100000)
        (values phi1 n1)
        (iterate phi1 n1))))

(multiple-value-bind (phi n) (iterate 1 0)
  (princ "Result: ")
  (princ phi)
  (princ " (")
  (princ (* 1.0 phi))
  (princ ") after ")
  (princ n)
  (princ " iterations")
  (terpri)
  (princ "The error is approximately ")
  (princ (- phi (* 0.5 (+ 1.0 (sqrt 5.0)))))
  (terpri))
