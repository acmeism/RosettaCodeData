#lang racket
(define point% ; classes are suffixed with % by convention
  (class object%
    (super-new)
    (init-field x y)))
