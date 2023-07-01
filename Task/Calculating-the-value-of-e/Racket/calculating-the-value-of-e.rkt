#lang racket
(require math/number-theory)

(define (calculate-e (terms 20))
  (apply + (map (compose / factorial) (range terms))))

(module+ main
  (let ((e (calculate-e)))
    (displayln e)
    (displayln (real->decimal-string e 20))
    (displayln (real->decimal-string (- (exp 1) e) 20))))
