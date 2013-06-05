#lang racket
(provide instance)
(define singleton%
  (class object%
    (super-new)))
(define instance (new singleton%))
