#lang racket
;; Using "helpful formulae" in:
;; http://en.wikipedia.org/wiki/Magic_square#Method_for_constructing_a_magic_square_of_odd_order
(define (squares n) n)

(define (last-no n) (sqr n))

(define (middle-no n) (/ (add1 (sqr n)) 2))

(define (M n) (* n (middle-no n)))

(define ((Ith-row-Jth-col n) I J)
  (+ (* (modulo (+ I J -1 (exact-floor (/ n 2))) n) n)
     (modulo (+ I (* 2 J) -2) n)
     1))

(define (magic-square n)
  (define IrJc (Ith-row-Jth-col n))
  (for/list ((I (in-range 1 (add1 n)))) (for/list ((J (in-range 1 (add1 n)))) (IrJc I J))))

(define (fmt-list-of-lists l-o-l width)
  (string-join
   (for/list ((row l-o-l))
     (string-join (map (λ (x) (~a #:align 'right #:width width x)) row) "  "))
   "\n"))

(define (show-magic-square n)
  (format "MAGIC SQUARE ORDER:~a~%~a~%MAGIC NUMBER:~a~%"
          n (fmt-list-of-lists (magic-square n) (+ (order-of-magnitude (last-no n)) 1)) (M n)))

(displayln (show-magic-square 3))
(displayln (show-magic-square 5))
(displayln (show-magic-square 9))
