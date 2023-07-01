#lang racket

(require math/number-theory
         racket/generator)

(define-syntax-rule (define/cache (name arg) body ...)
  (begin
    (define cache (make-hash))
    (define (name arg)
      (hash-ref! cache arg (lambda () body ...)))))

(define/cache (primorial n)
  (if (zero? n)
     1
     (* (nth-prime (sub1 n))
        (primorial (sub1 n)))))

(for ([i (in-range 20)]
      [n (in-generator (for ([i (in-naturals 1)])
                         (define pr (primorial i))
                         (when (or (prime? (add1 pr)) (prime? (sub1 pr)))
                           (yield i))))])
  (displayln n))
