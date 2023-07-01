(define Y2r
  (lambda (f)
    (lambda a (apply (f (Y2r f)) a))))
