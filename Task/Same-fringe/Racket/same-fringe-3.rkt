#lang racket

(define (pipe-fringe tree)
  (define-values [I O] (make-pipe 100))
  (thread (λ() (let loop ([tree tree])
                 (if (list? tree) (for-each loop tree) (fprintf O "~s\n" tree)))
               (close-output-port O)))
  I)

(define (same-fringe? tree1 tree2)
  (define i1 (pipe-fringe tree1))
  (define i2 (pipe-fringe tree2))
  (let loop ()
    (let ([x1 (read i1)] [x2 (read i2)])
      (and (equal? x1 x2) (or (eof-object? x1) (loop))))))
