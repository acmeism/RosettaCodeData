#lang racket
;; {{trans|Sidef}}
;; vectors are represented by lists

(struct Line (P0 u⃗))

(struct Plane (V0 n⃗))

(define (· a b) (apply + (map * a b)))

(define (line-plane-intersection L P)
  (match-define (cons (Line P0 u⃗) (Plane V0 n⃗)) (cons L P))
  (define cos (· n⃗ u⃗))
  (when (zero? cos) (error "vectors are orthoganal"))
  (define W (map - P0 V0))
  (define *SI (let ((SI (- (/ (· n⃗ W) cos)))) (λ (n) (* SI n))))
  (map + W (map *SI u⃗) V0))

(module+ test
  (require rackunit)
  (check-equal?
   (line-plane-intersection (Line '(0 0 10) '(0 -1 -1))
                            (Plane '(0 0 5) '(0 0 1)))
   '(0 -5 5)))
