#lang racket

(provide (contract-out [x 1-to-10/c]))

(define 1-to-10/c (between/c 1 10))

(define x 5)
