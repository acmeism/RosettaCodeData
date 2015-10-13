#lang racket

(define (fringe->channel tree)
  (define ch (make-channel))
  (thread (λ() (let loop ([tree tree])
                 (if (list? tree) (for-each loop tree) (channel-put ch tree)))
               (channel-put ch (void)))) ; mark the end
  ch)

(define (same-fringe? tree1 tree2)
  (define ch1 (fringe->channel tree1))
  (define ch2 (fringe->channel tree2))
  (let loop ()
    (let ([x1 (channel-get ch1)] [x2 (channel-get ch2)])
      (and (equal? x1 x2) (or (void? x1) (loop))))))
