(define filter
  (lambda (fn lst)
    (let iter ((lst lst) (result '()))
      (if (null? lst)
         (reverse result)
         (let ((item (car lst))
               (rest (cdr lst)))
           (if (fn item)
               (iter rest (cons item result))
               (iter rest result)))))))