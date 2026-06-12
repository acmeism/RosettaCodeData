#lang racket/base
(define (two-sum v m)
  (let inr ((l 0) (r (sub1 (vector-length v))))
    (and
     (not (= l r))
     (let ((s (+ (vector-ref v l) (vector-ref v r))))
       (cond [(= s m) (list l r)] [(> s m) (inr l (sub1 r))] [else (inr (add1 l) r)])))))

(module+ test
  (require rackunit)
  ;; test cases
  ;; no output indicates returns are as expected
  (check-equal? (two-sum #( 0  2 11 19 90)      21) '(1 3))
  (check-equal? (two-sum #(-8 -2  0  1  5 8 11)  3) '(0 6))
  (check-equal? (two-sum #(-3 -2  0  1  5 8 11) 17) #f)
  (check-equal? (two-sum #(-8 -2 -1  1  5 9 11)  0) '(2 3)))
