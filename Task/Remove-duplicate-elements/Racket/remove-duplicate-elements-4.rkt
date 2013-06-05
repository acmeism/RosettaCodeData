(define (unique seq #:same-test [same? equal?])
  (for/fold ([res '()])
            ([x seq] #:unless (memf (curry same? x) res))
    (cons x res)))
