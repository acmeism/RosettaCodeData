(defun sum-3-5 (n)
  (apply #'+ (seq-filter
	      (lambda (x) (or (zerop (% x 3) ) (zerop (% x 5))))
	      (number-sequence 1 (- n 1)))))
