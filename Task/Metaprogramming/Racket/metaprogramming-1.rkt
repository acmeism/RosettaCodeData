#lang racket

(define-syntax-rule (list-when test body)
  (if test
      body
      '()))

(let ([not-a-string 42])
  (list-when (string? not-a-string)
    (string->list not-a-string)))
