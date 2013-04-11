(defun arithmetic-average (samples)
  (/ (reduce #'+ samples)
     (length samples)))

(defun standard-deviation (samples)
  (let ((mean (arithmetic-average samples)))
    (sqrt (* (/ 1.0d0 (length samples))
             (reduce #'+ samples
                     :key (lambda (x)
                            (expt (- x mean) 2)))))))

(defun make-deviator ()
  (let ((numbers '()))
    (lambda (x)
      (push x numbers)
      (standard-deviation numbers))))
