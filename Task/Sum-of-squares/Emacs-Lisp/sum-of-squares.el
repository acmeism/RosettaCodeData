(defun sum-of-squares (numbers)
  (apply #'+ (mapcar (lambda (k) (* k k)) numbers)))

(sum-of-squares (number-sequence 0 3)) ;=> 14
