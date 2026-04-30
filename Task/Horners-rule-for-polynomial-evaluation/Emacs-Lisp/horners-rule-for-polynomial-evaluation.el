(require 'cl-lib)

(defun horner (coeffs x)
  (cl-reduce #'(lambda (coef acc) (+ (* acc x) coef))
	     coeffs :from-end t :initial-value 0))

(horner '(-19 7 -4 6) 3)
