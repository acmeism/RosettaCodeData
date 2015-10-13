(defun powerset (s)
  (if s (mapcan (lambda (x) (list (cons (car s) x) x))
                (powerset (cdr s)))
      '(())))
