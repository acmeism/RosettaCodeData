(define (string-repeat n str)
  (apply string-append (vector->list (make-vector n str))))
