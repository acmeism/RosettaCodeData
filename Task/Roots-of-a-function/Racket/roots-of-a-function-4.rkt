(define (memoized f)
  (define tbl (make-hash))
  (λ x
    (cond [(hash-ref tbl x #f) => values]
          [else (define res (apply f x))
                (hash-set! tbl x res)
                res])))
