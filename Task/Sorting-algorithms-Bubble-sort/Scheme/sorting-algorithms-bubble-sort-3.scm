(define (bsort l gt?)
  (define (dosort l)
    (cond ((null? (cdr l))
           l)
          ((gt? (car l) (cadr l))
           (cons (cadr l) (dosort (cons (car l) (cddr l)))))
          (else
           (cons (car l) (dosort (cdr l))))))
  (let ((try (dosort l)))
    (if (equal? l try)
        l
        (bsort try gt?))))
