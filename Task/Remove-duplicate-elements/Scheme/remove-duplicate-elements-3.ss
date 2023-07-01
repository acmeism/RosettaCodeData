(define (remove-duplicates l)
  (do ((a '() (if (member (car l) a) a (cons (car l) a)))
       (l l (cdr l)))
    ((null? l) (reverse a))))

(remove-duplicates '(1 2 1 3 2 4 5))
