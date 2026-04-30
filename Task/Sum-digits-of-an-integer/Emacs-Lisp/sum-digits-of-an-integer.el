(defun digit-sum (n)
  (apply #'+ (mapcar (lambda (c) (- c ?0)) (string-to-list (number-to-string n)))))

(digit-sum 1234)
