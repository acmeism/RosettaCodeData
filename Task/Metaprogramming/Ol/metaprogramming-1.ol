(define-syntax define
   (syntax-rules (lambda) ;λ
      ((define ((name . args) . more) . body)
         (define (name . args) (lambda more . body)))
      ((define (name . args) . body)
         (setq name (letq (name) ((lambda args . body)) name)))
      ((define name (lambda (var ...) . body))
         (setq name (letq (name) ((lambda (var ...) . body)) name)))
      ((define name val)
         (setq name val))
      ((define name a b . c)
         (define name (begin a b . c)))))
