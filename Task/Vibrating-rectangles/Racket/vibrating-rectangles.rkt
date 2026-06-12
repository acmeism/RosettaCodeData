#lang racket

(require 2htdp/image
         2htdp/universe)

(define N 20)
(define SIZE 400)
(define OFFSET 80)
(define RATE 0.2)

;; a state is a pair of color index and position

(define colors '(red orange yellow green blue indigo violet))
(define (mod x) (modulo x (length colors)))

(big-bang (cons 0 (sub1 N))
  [on-tick
   (match-lambda
     [(cons m 0) (cons (mod (add1 m)) (sub1 N))]
     [(cons m n) (cons m (sub1 n))])
   RATE]
  [to-draw
   (match-lambda
     [(cons m n)
      (apply
       overlay
       (append
        (for/list ([i (in-range N 0 -1)])
          (square (* i (/ (- SIZE OFFSET) N))
                  'outline
                  (if (> i n)
                      (list-ref colors (mod (add1 m)))
                      (list-ref colors m))))
        (list (empty-scene SIZE SIZE 'black))))])])
