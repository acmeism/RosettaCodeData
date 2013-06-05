(define (my-max l)
  (for/fold ([max #f]) ([x l])
    (if (and max (> max x)) max x)))
