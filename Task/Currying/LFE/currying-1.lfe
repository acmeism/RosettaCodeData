(defun curry (f arg)
  (lambda (x)
    (apply f
      (list arg x))))
