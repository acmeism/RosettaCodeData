#lang racket
(provide instance)
(define instance
  (new (class object%
         (define/public (foo) 123)
         (super-new))))
