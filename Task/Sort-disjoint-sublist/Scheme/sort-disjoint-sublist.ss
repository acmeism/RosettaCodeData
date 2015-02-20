(use gauche.sequence)
(define num-list '(7 6 5 4 3 2 1 0))
(define indices '(6 1 7))
(define table
  (alist->hash-table
    (map cons
      (sort indices)
      (sort indices < (lambda (x) (~ num-list x))))))

(map last
  (sort
    (map-with-index
      (lambda (i x) (list (hash-table-get table i i) x))
      num-list)
    <
    car))
