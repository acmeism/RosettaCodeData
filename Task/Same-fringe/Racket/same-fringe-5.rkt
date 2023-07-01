#lang racket

(require racket/control)

(define (fringe-iterator tree)
  (λ() (let loop ([tree tree])
         (if (list? tree) (for-each loop tree) (fcontrol tree)))
       (fcontrol (void))))

(define (same-fringe? tree1 tree2)
  (let loop ([iter1 (fringe-iterator tree1)]
             [iter2 (fringe-iterator tree2)])
    (% (iter1)
       (λ (x1 iter1)
         (% (iter2)
            (λ (x2 iter2)
              (and (equal? x1 x2)
                   (or (void? x1) (loop iter1 iter2)))))))))
