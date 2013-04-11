#lang racket

(struct t-node (color t-left value t-right))

(define (balance t)
  (match t
    [(t-node 'black (t-node 'red (t-node 'red a x b) y c) z d)
     (t-node 'red (t-node 'black a x b) y (t-node 'black c z d))]
    [(t-node 'black (t-node 'red a x (t-node 'red b y c)) z d)
     (t-node 'red (t-node 'black a x b) y (t-node 'black c z d))]
    [(t-node 'black a x (t-node 'red (t-node 'red b y c) z d))
     (t-node 'red (t-node 'black a x b) y (t-node 'black c z d))]
    [(t-node 'black a x (t-node 'red b y (t-node 'red c z d)))
     (t-node 'red (t-node 'black a x b) y (t-node 'black c z d))]
    [else t]))

(define (insert x s)
  (define (ins t)
    (match t
      ['empty (t-node 'red 'empty x 'empty)]
      [(t-node c a y b)
       (cond [(< x y)
              (balance (t-node c (ins a) y b))]
             [(> x y)
              (balance (t-node c a y (ins b)))]
             [else t])]))
  (match (ins s)
    [(t-node _ a y b) (t-node 'black a y b)]))
