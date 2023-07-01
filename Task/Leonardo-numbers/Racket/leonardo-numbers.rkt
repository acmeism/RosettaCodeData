#lang racket
(define (Leonardo n #:L0 (L0 1) #:L1 (L1 1) #:1+ (1+ 1))
  (cond [(= n 0) L0]
        [(= n 1) L1]
        [else
         (let inr ((n (- n 2)) (L_n-2 L0) (L_n-1 L1))
           (let ((L_n (+ L_n-1 L_n-2 1+)))
             (if (zero? n) L_n (inr (sub1 n) L_n-1 L_n))))]))

(module+ main
  (map Leonardo (range 25))
  (map (curry Leonardo #:L0 0 #:L1 1 #:1+ 0) (range 25)))

(module+ test
  (require rackunit)
  (check-equal? (Leonardo 0) 1)
  (check-equal? (Leonardo 1) 1)
  (check-equal? (Leonardo 2) 3)
  (check-equal? (Leonardo 3) 5))
