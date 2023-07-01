(define (ffr n)
  (hash-ref r-cache n (lambda () (extend-r-s!) (ffr n))))

(define (ffs n)
  (hash-ref s-cache n (lambda () (extend-r-s!) (ffs n))))
