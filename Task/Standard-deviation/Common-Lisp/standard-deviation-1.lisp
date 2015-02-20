(defun std-dev (samples)
  (let* ((n (length samples))
	 (mean (/ (reduce #'+ samples) n))
	 (tmp (mapcar (lambda (x) (expt (- x mean) 2)) samples)))
    (sqrt (/ (reduce #'+ tmp) n))))

(format t "~a" (std-dev '(2 4 4 4 5 5 7 9)))
