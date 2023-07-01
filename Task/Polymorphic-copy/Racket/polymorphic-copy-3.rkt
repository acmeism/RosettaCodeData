;#lang racket

(define point%
  (class object%
    (super-new)
    (init-field x y)
    (define/public (clone) (new this% [x x] [y y]))
    (define/public (to-list) (list this% x y))))

(define point/color%
  (class point%
    (super-new)
    (inherit-field x y)
    (init-field color)
    (define/override (clone) (new this% [x x] [y y] [color color]))
    (define/override (to-list) (list this% x y color))))
