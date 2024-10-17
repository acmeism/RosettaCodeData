(define (bubble-sort x gt?)
  (letrec
    ((fix (lambda (f i)
       (if (equal? i (f i))
           i
           (fix f (f i)))))

     (sort-step (lambda (l)
        (if (or (null? l) (null? (cdr l)))
            l
            (if (gt? (car l) (cadr l))
                (cons (cadr l) (sort-step (cons (car l) (cddr l))))
                (cons (car  l) (sort-step (cdr l))))))))

  (fix sort-step x)))
