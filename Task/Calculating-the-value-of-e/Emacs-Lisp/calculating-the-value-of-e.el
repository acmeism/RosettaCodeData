(defun factorial (i)
  "Compute factorial of i."
  (apply #'* (number-sequence 1 i)))

(defun compute-e (iter)
  "Compute e."
  (apply #'+ 1 (mapcar (lambda (x) (/ 1.0 x))
    (mapcar #'factorial (number-sequence 1 iter)))))

(compute-e 20)
