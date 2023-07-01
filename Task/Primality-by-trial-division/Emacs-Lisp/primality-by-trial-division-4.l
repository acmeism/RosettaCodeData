(defun prime4 (a)
  (not (or (< a 2)
           (cl-some (lambda (x) (zerop (% a x))) (number-sequence 2 (sqrt a))))))
