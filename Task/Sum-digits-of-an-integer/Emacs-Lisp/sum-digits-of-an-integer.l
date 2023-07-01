(defun digit-sum (n)
  (apply #'+ (mapcar (lambda (c) (- c ?0)) (string-to-list "123"))))

(digit-sum 1234) ;=> 10
