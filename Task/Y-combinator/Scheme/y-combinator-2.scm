(define Yr        ; (Y f) == (f  (lambda a (apply (Y f) a)))
  (lambda (f)
    (f  (lambda a (apply (Yr f) a)))))
