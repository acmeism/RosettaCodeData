#lang racket/base

(define-syntax-rule (define/memoize1 (proc x) body ...)
  (define proc
    (let ([cache (make-hash)]
          [direct (lambda (x) body ...)])
      (lambda (x)
        (hash-ref! cache x (lambda () (direct x)))))))

(define/memoize1 (conway n)
  (if (< n 3)
      1
      (+ (conway (conway (sub1 n)))
         (conway (- n (conway (sub1 n)))))))
