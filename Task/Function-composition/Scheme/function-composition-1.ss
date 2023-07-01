(define (compose f g) (lambda (x) (f (g x))))

;; or:

(define ((compose f g) x) (f (g x)))

;; or to compose an arbitrary list of 1 argument functions:

(define-syntax compose
  (lambda (x)
    (syntax-case x ()
      ((_) #'(lambda (y) y))
      ((_ f) #'f)
      ((_ f g h ...)  #'(lambda (y) (f ((compose g h ...) y)))))))
