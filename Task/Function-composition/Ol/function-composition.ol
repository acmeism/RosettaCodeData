(define (compose f g)
   (lambda (x) (f (g x))))

;; or:

(define ((compose f g) x) (f (g x)))
