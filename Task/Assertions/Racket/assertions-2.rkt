#lang racket

(define x 80)
(unless (= x 42)
  (error "a is not 42")) ; will error
