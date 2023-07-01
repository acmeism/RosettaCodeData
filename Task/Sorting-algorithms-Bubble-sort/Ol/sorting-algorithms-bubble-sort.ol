(define (bubble-sort x ??)
   (define (sort-step l)
      (if (or (null? l) (null? (cdr l)))
         l
         (if (?? (car l) (cadr l))
            (cons (cadr l) (sort-step (cons (car l) (cddr l))))
            (cons (car  l) (sort-step (cdr l))))))
   (let loop ((i x))
      (if (equal? i (sort-step i))
         i
         (loop (sort-step i)))))

(print
   (bubble-sort (list 1 3 5 9 8 6 4 3 2) >))
(print
   (bubble-sort (iota 100) >))
(print
   (bubble-sort (iota 100) <))
