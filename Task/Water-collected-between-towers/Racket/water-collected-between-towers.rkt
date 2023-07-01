#lang racket/base
(require racket/match)

(define (water-collected-between-towers towers)
  (define (build-tallest-left/rev-list t mx/l rv)
    (match t
      [(list) rv]
      [(cons a d)
       (define new-mx/l (max a mx/l))
       (build-tallest-left/rev-list d new-mx/l (cons mx/l rv))]))

  (define (collect-from-right t tallest/l mx/r rv)
    (match t
      [(list) rv]
      [(cons a d)
       (define new-mx/r (max a mx/r))
       (define new-rv (+ rv (max (- (min new-mx/r (car tallest/l)) a) 0)))
       (collect-from-right d (cdr tallest/l) new-mx/r new-rv)]))

  (define reversed-left-list (build-tallest-left/rev-list towers 0 null))
  (collect-from-right (reverse towers) reversed-left-list 0 0))

(module+ test
  (require rackunit)
  (check-equal?
   (let ((towerss
          '[[1 5 3 7 2]
            [5 3 7 2 6 4 5 9 1 2]
            [2 6 3 5 2 8 1 4 2 2 5 3 5 7 4 1]
            [5 5 5 5]
            [5 6 7 8]
            [8 7 7 6]
            [6 7 10 7 6]]))
     (map water-collected-between-towers towerss))
   (list 2 14 35 0 0 0 0)))
