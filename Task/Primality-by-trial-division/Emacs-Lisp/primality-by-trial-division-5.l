(defun prime5 (a)
  (not (or (< a 2)
           (and (/= a 2) (evenp a))
           (some (lambda (x) (zerop (% a x))) (number-sequence 3 (sqrt a) 2)))))
