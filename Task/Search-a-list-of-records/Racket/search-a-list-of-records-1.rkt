#lang racket

(define (findf/pos proc lst)
  (let loop ([lst lst] [pos 0])
    (cond
      [(null? lst) #f]
      [(proc (car lst)) pos]
      [else (loop (cdr lst) (add1 pos))])))
