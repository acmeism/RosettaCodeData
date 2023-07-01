#lang racket

(define-syntax-rule (define/mem (name args ...) body ...)
  (begin
    (define cache (make-hash))
    (define (name args ...)
      (hash-ref! cache (list args ...) (lambda () body ...)))))

(define (take-last x n)
  (drop x (- (length x) n)))

(define (borders x)
  (if (> (length x) 5)
    (append (take x 2) '(...) (take-last x 2))
    x))

(define (add-tail list x)
  (reverse (cons x (reverse list))))
