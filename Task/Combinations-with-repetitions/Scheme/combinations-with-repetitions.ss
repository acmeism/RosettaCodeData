(define combinations
  (lambda (lst k)
    (cond ((= k 0) '(()))
          ((null? lst) '())
          (else
           (append
            (map
             (lambda (x)
               (cons (car lst) x))
             (combinations lst (- k 1)))
            (combinations (cdr lst) k))))))
