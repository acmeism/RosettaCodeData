#lang racket
(define (consolidate ss)
  (define (comb s cs)
    (cond [(set-empty? s) cs]
          [(empty? cs) (list s)]
          [(set-empty? (set-intersect s (first cs)))
           (cons (first cs) (comb s (rest cs)))]
          [(consolidate (cons (set-union s (first cs)) (rest cs)))]))
  (foldl comb '() ss))

(consolidate (list (set 'a 'b) (set 'c 'd)))
(consolidate (list (set 'a 'b) (set 'b 'c)))
(consolidate (list (set 'a 'b) (set 'c 'd) (set 'd 'b)))
(consolidate (list (set 'h 'i 'k) (set 'a 'b) (set 'c 'd) (set 'd 'b) (set 'f 'g 'h)))
