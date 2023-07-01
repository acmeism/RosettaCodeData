#lang racket/base
(define (jort-sort l [<? <])
  (equal? l (sort l <?)))
