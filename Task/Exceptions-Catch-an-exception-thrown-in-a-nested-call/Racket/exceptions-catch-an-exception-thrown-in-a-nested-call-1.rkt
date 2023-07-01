#lang racket

(define-struct (exn:U0 exn) ())
(define-struct (exn:U1 exn) ())

(define (foo)
  (for ([i 2])
    (with-handlers ([exn:U0? (λ(_) (displayln "Function foo caught exception U0"))])
      (bar i))))

(define (bar i)
  (baz i))

(define (baz i)
  (if (= i 0)
      (raise (make-exn:U0 "failed 0" (current-continuation-marks)))
      (raise (make-exn:U1 "failed 1" (current-continuation-marks)))))

(foo)
