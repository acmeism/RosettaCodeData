#lang racket
(require math/matrix)
(define T matrix-transpose)

(define (convolution-matrix f m n)
  (define l (matrix-num-rows f))
  (for*/matrix m n ([i (in-range 0 m)] [j (in-range 0 n)])
      (cond [(or  (< i j) (>= i (+ j l)))  0]
            [(matrix-ref f (- i j) 0)])))

(define (least-square X y)
  (matrix-solve (matrix* (T X) X) (matrix* (T X) y)))

(define (deconvolve g f)
  (define lg (matrix-num-rows g))
  (define lf (matrix-num-rows f))
  (define lh (+ (- lg lf) 1))
  (least-square (convolution-matrix f lg lh) g))
