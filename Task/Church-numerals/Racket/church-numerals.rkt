#lang racket

(define zero (λ (f) (λ (x) x)))
(define zero* (const identity)) ; zero renamed

(define one (λ (f) f))
(define one* identity) ; one renamed

(define succ (λ (n) (λ (f) (λ (x) (f ((n f) x))))))
(define succ* (λ (n) (λ (f) (λ (x) ((n f) (f x)))))) ; different impl

(define add (λ (n) (λ (m) (λ (f) (λ (x) ((m f) ((n f) x)))))))
(define add* (λ (n) (n succ)))

(define succ** (add one))

(define mult (λ (n) (λ (m) (λ (f) (m (n f))))))
(define mult* (λ (n) (λ (m) ((m (add n)) zero))))

(define expt  (λ (n) (λ (m) (m n))))
(define expt* (λ (n) (λ (m) ((m (mult n)) one))))

(define (nat->church n)
  (cond
    [(zero? n) zero]
    [else (succ (nat->church (sub1 n)))]))

(define (church->nat n) ((n add1) 0))

(define three (nat->church 3))
(define four (nat->church 4))

(church->nat ((add three) four))
(church->nat ((mult three) four))
(church->nat ((expt three) four))
(church->nat ((expt four) three))
