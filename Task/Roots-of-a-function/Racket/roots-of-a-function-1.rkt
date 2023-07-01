#lang racket

;; Attempts to find all roots of a real-valued function f
;; in a given interval [a b] by dividing the interval into N parts
;; and using the root-finding method on each subinterval
;; which proves to contain a root.
(define (find-roots f a b
                    #:divisions [N 10]
                    #:method [method secant])
  (define h (/ (- b a) N))
  (for*/list ([x1 (in-range a b h)]
              [x2 (in-value (+ x1 h))]
              #:when (or (root? f x1)
                         (includes-root? f x1 x2)))
    (find-root f x1 x2 #:method method)))

;; Finds a root of a real-valued function f
;; in a given interval [a b].
(define (find-root f a b #:method [method secant])
  (cond
    [(root? f a) a]
    [(root? f b) b]
    [else (and (includes-root? f a b) (method f a b))]))

;; Returns #t if x is a root of a real-valued function f
;; with absolute accuracy (tolerance).
(define (root? f x) (almost-equal? 0 (f x)))

;; Returns #t if interval (a b) contains a root
;; (or the odd number of roots) of a real-valued function f.
(define (includes-root? f a b) (< (* (f a) (f b)) 0))

;; Returns #t if a and b are equal with respect to
;; the relative accuracy (tolerance).
(define (almost-equal? a b)
  (or (< (abs (+ b a)) (tolerance))
      (< (abs (/ (- b a) (+ b a))) (tolerance))))

(define tolerance (make-parameter 5e-16))
