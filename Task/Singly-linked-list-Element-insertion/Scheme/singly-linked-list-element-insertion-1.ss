(define (insert-after a b lst)
  (if (null? lst)
      lst       ; This should be an error, but we will just return the list untouched
      (let ((c (car lst))
            (cs (cdr lst)))
        (if (equal? a c)
            (cons a (cons b cs))
            (cons c (insert-after a b cs))))))
