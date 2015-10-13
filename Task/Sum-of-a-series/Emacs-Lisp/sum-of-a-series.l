(defun serie (n)
  (if (< 0 n)
      (apply '+ (mapcar (lambda (k) (/ 1.0 (* k k) )) (number-sequence 1 n) ))
    (error "input error") ))

(insert (format "%.10f" (serie 1000) ))
