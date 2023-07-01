#lang lazy
(provide minimax)

(define (minimax tree)
  (! (let minimax ([node tree] [α -inf.0] [β +inf.0] [max-player #f])
       (cond
         [(number? node) node]
         [(empty? node) 0.0]
         [max-player
          (let next ([x node] [α α])
            (if (or (empty? x) (<= β α))
                α
                (next (cdr x)
                      (max α (minimax (car x) α β (not max-player))))))]
         [else
          (let next ([x node] [β β])
            (if (or (empty? x) (<= β α))
                β
                (next (cdr x)
                      (min β (minimax (car x) α β (not max-player))))))]))))
