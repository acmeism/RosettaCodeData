(define Y2                ; (Y2 f) = (g g) where
  (lambda (f)             ;          (g g) = (lambda a (apply (f (g g)) a))
    ((lambda (g) (g g))   ; (Y2 f) ==       (lambda a (apply (f (Y2 f)) a))
     (lambda (g)
       (lambda a (apply (f (g g)) a))))))
