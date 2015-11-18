#lang racket
(require racket/generator)

(define (fringe-generator tree)
  (generator ()
    (let loop ([tree tree])
      (if (list? tree) (for-each loop tree) (yield tree)))))

(define (same-fringe? tree1 tree2)
  (define g1 (fringe-generator tree1))
  (define g2 (fringe-generator tree2))
  (let loop ()
    (let ([x1 (g1)] [x2 (g2)])
      (and (equal? x1 x2) (or (void? x1) (loop))))))
