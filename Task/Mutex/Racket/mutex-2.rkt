(define-syntax-rule (define/atomic (name arg ...) E ...)
  (define name
    (let ([sema (make-semaphore 1)])
      (lambda (arg ...)
        (dynamic-wind (λ() (semaphore-wait sema))
                      (λ() E ...)
                      (λ() (semaphore-post sema)))))))
;; this does the same as the above now:
(define/atomic (foo x)
  (... do something ...))
