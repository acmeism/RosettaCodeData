(define-class stack
    (instance-variables vals))

(define-method (stack 'initialize)
    (setq vals '())
    self)

(define-method (stack 'push x)
    (setq vals (cons x vals)))

(define-method (stack 'pop)
    (define tos (car vals))
    (setq vals (cdr vals))
    tos)

(define-method (stack 'emptyp)
    (null vals))
