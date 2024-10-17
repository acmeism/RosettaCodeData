(define (print-all . things)
    (for-each
        (lambda (x) (display x) (newline))
        things))
