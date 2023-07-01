(define-class animal)

(define-class dog
    (super-class animal))

(define-class cat
    (super-class animal))

(define-class collie
    (super-class dog))

(define-class lab
    (super-class dog))
