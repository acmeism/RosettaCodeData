(defun series (n)
  (when (<= n 0)
    (user-error "n must be positive"))
  (apply #'+ (mapcar (lambda (k) (/ 1.0 (* k k))) (number-sequence 1 n))))

(format "%.10f" (series 1000)) ;=> "1.6439345667"
