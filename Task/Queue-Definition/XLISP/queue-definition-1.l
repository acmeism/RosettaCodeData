(define-class queue
    (instance-variables vals))

(define-method (queue 'initialize)
    (setq vals '())
    self)

(define-method (queue 'push x)
    (setq vals (nconc vals (cons x nil))))

(define-method (queue 'pop)
    (define val (car vals))
    (setq vals (cdr vals))
    val)

(define-method (queue 'emptyp)
    (null vals))
