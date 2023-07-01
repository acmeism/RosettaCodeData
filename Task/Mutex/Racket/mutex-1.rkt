(define foo
  (let ([sema (make-semaphore 1)])
    (lambda (x)
      (dynamic-wind (λ() (semaphore-wait sema))
                    (λ() (... do something ...))
                    (λ() (semaphore-post sema))))))
