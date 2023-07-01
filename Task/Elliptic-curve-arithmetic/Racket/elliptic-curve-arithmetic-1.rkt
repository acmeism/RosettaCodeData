#lang racket
(define a 0) (define b 7)
(define (ε? x) (<= (abs x) 1e-14))
(define (== p q) (for/and ([pi p] [qi q]) (ε? (- pi qi))))
(define zero #(0 0))
(define (zero? p) (== p zero))
(define (neg p) (match-define (vector x y) p) (vector x (- y)))
(define (⊕ p q)
  (cond [(== q (neg p)) zero]
        [else
         (match-define (vector px py) p)
         (match-define (vector qx qy) q)
         (define (done λ px py qx)
           (define x (- (* λ λ) px qx))
           (vector x (- (+ (* λ (- x px)) py))))
         (cond [(and (== p q) (ε? py)) zero]
               [(or (== p q) (ε? (- px qx)))
                (done (/ (+ (* 3 px px) a) (* 2 py)) px py qx)]
               [(done (/ (- py qy) (- px qx)) px py qx)])]))
(define (⊗ p n)
  (cond [(= n 0)       zero]
        [(= n 1)       p]
        [(= n 2)       (⊕ p p)]
        [(negative? n) (neg (⊗ p (- n)))]
        [(even? n)     (⊗ (⊗ p (/ n 2)) 2)]
        [(odd? n)      (⊕ p (⊗ p (- n 1)))]))
