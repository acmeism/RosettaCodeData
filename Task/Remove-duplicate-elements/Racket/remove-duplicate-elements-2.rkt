(define (unique/hash lst)
  (hash-keys (for/hash ([x (in-list lst)]) (values x #t))))
