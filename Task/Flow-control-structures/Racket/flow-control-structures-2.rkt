(define (list-product l)
  (with-handlers ([void identity])
    (let loop ([l l] [r 1])
      (cond [(null? l) r]
            [(zero? (car l)) (raise 0)]
            [else (loop (cdr l) (* r (car l)))]))))
