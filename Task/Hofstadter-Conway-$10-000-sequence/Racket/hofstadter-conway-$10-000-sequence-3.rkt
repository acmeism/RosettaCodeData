(define-syntax-rule (for/prev (sequences ...) body ...)
  (for/fold ([prev #f]) (sequences ...)
    (define val (let () body ...))
    #:break (not val)
    val))

(define mallows (for/prev ([i (in-naturals)])
                   (define low-b (expt 2 i))
                   (define up-b (expt 2 (add1 i)))
                   (for/last ([k (in-range low-b up-b)]
                              #:when (>= (/ (conway k) k) .55))
                     k)))

(printf "Mallows number: ~a~n" mallows)
