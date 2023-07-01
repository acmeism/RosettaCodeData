#lang racket/base

(struct ng (a1 a b1 b) #:transparent #:mutable)

(define (ng-ingress! v t)
  (define a (ng-a v))
  (define a1 (ng-a1 v))
  (define b (ng-b v))
  (define b1 (ng-b1 v))
  (set-ng-a! v a1)
  (set-ng-a1! v (+ a (* a1 t)))
  (set-ng-b! v b1)
  (set-ng-b1! v (+ b (* b1 t))))

(define (ng-needterm? v)
  (or (zero? (ng-b v))
      (zero? (ng-b1 v))
      (not (= (quotient (ng-a v) (ng-b v)) (quotient (ng-a1 v) (ng-b1 v))))))

(define (ng-egress! v)
  (define t (quotient (ng-a v) (ng-b v)))
  (define a (ng-a v))
  (define a1 (ng-a1 v))
  (define b (ng-b v))
  (define b1 (ng-b1 v))
  (set-ng-a! v b)
  (set-ng-a1! v b1)
  (set-ng-b! v (- a (* b t)))
  (set-ng-b1! v (- a1 (* b1 t)))
  t)

(define (ng-infty! v)
  (when (ng-needterm? v)
    (set-ng-a! v (ng-a1 v))
    (set-ng-b! v (ng-b1 v))))

(define (ng-done? v)
  (and (zero? (ng-b v)) (zero? (ng-b1 v))))
