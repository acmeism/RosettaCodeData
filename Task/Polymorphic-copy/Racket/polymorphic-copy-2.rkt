#lang racket/base

(define (copy-struct str)
  (define-values (str-struct-info _) (struct-info str))
  (define str-maker (struct-type-make-constructor str-struct-info))
  (apply str-maker (cdr (vector->list (struct->vector str)))))

(struct point (x y) #:transparent)
(struct point/color point (color) #:transparent)

(let* ([original (point 0 0)]
       [copied (copy-struct original)])
  (displayln copied)
  (displayln (eq? original copied)))

(let* ([original (point/color 0 0 'black)]
       [copied (copy-struct original)])
  (displayln copied)
  (displayln (eq? original copied)))
