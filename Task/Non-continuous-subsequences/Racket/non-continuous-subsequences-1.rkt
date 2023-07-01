(define (subsets l)
  (if (null? l) '(())
      (append (for/list ([l2 (subsets (cdr l))]) (cons (car l) l2))
              (subsets (cdr l)))))
