#lang racket
(require math)
(define (factors n)
  (append-map (λ (x) (make-list (cadr x) (car x))) (factorize n)))
