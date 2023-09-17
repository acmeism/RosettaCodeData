(defun sum-of-squares (vec)
  (reduce #'+ (map 'vector (lambda (x) (* x x)) vec)))
