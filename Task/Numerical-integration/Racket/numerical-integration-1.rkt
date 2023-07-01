#lang racket
(define (integrate f a b steps meth)
  (define h (/ (- b a) steps))
  (* h (for/sum ([i steps])
         (meth f (+ a (* h i)) h))))

(define (left-rect f x h) (f x))
(define (mid-rect f x h)  (f (+ x (/ h 2))))
(define (right-rect f x h)(f (+ x h)))
(define (trapezium f x h) (/ (+ (f x) (f (+ x h))) 2))
(define (simpson f x h)   (/ (+ (f x) (* 4 (f (+ x (/ h 2)))) (f (+ x h))) 6))

(define (test f a b s n)
  (displayln n)
  (for ([meth (list left-rect mid-rect right-rect trapezium simpson)]
        [name '(    left-rect mid-rect right-rect trapezium simpson)])
    (displayln (~a name ":\t" (integrate f a b s meth))))
  (newline))

(test (λ(x) (* x x x)) 0.    1.     100 "CUBED")
(test (λ(x) (/ x))     1.  100.    1000 "RECIPROCAL")
(test (λ(x) x)         0. 5000. 5000000 "IDENTITY")
(test (λ(x) x)         0. 6000. 6000000 "IDENTITY")
