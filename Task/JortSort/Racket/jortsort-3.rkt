#lang racket/base
(define (jort-sort l [<? <])
  (or (null? l)
      (for/and ([x (in-list l)] [y (in-list (cdr l))])
        (not (&lt;? y x))))) ; same as (&lt;= x y) but using only &lt;?
