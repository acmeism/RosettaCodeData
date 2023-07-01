(define (quicksort l ??)
  (if (null? l)
      '()
      (append (quicksort (filter (lambda (x) (?? (car l) x)) (cdr l)) ??)
              (list (car l))
              (quicksort (filter (lambda (x) (not (?? (car l) x))) (cdr l)) ??))))

(print
   (quicksort (list 1 3 5 9 8 6 4 3 2) >))
(print
   (quicksort (iota 100) >))
(print
   (quicksort (iota 100) <))
