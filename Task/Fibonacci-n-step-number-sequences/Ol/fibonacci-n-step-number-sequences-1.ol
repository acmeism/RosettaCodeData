(define (n-fib-iterator ll)
   (cons (car ll)
         (lambda ()
            (n-fib-iterator (append (cdr ll) (list (fold + 0 ll)))))))
