#lang racket/base
(define (jort-sort l [<? <])
  (eq? l (sort l <?)))
