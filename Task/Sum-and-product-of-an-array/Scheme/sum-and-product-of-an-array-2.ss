(define (reduce f i l)
  (if (null? l)
    i
    (reduce f (f i (car l)) (cdr l))))

(reduce + 0 '(1 2 3 4 5)) ;; 0 is unit for +
(reduce * 1 '(1 2 3 4 5)) ;; 1 is unit for *
