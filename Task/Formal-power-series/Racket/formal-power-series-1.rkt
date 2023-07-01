#lang lazy

(require racket/match)

;; element-wise addition and subtraction
(define (<+> s1 s2) (map + s1 s2))
(define (<-> s1 s2) (map - s1 s2))

;; element-wise scaling
(define (scale a s) (map (λ (x) (* a x)) s))

;; series multiplication
(define (<*> fs gs)
  (match-let ([(cons f ft) (! fs)]
              [(cons g gt) (! gs)])
    (cons (* f g) (<+> (scale f gt) (<*> ft gs)))))

;; series division
(define (</> fs gs)
  (match-letrec ([(cons f ft) (! fs)]
                 [(cons g gt) (! gs)]
                 [qs (cons (/ f g) (scale (/ g) (<-> ft (<*> qs gt))))])
      qs))

;; integration and differentiation
(define (int f) (map / f (enum 1)))
(define (diff f) (map * (cdr f) (enum 1)))

;; series of natural numbers greater then n
(define (enum n) (cons n (enum (+ 1 n ))))
