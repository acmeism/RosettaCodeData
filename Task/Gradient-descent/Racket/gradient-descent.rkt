#lang racket

(define (apply-vector f v)
  (apply f (vector->list v)))

;; Provides a rough calculation of gradient g(v).
(define ((grad/del f) v δ #:fv (fv (apply-vector f v)))
  (define dim (vector-length v))
  (define tmp (vector-copy v))
  (define grad (for/vector #:length dim ((i dim)
                            (v_i v))
              (vector-set! tmp i (+ v_i δ))
              (define ∂f/∂v_i (/ (- (apply-vector f tmp) fv) δ))
              (vector-set! tmp i v_i)
              ∂f/∂v_i))
  (values grad (sqrt (for/sum ((∂_i grad)) (sqr ∂_i)))))

(define (steepest-descent g x α tolerance)
  (define grad/del-g (grad/del g))

  (define (loop x δ α gx grad-gx del-gx b)
    (cond
      [(<= del-gx tolerance) x]
      [else
        (define δ´ (/ δ 2))
        (define x´ (vector-map + (vector-map (curry * (- b)) grad-gx) x))
        (define gx´ (apply-vector g x´))
        (define-values (grad-gx´ del-gx´) (grad/del-g x´ δ´ #:fv gx´))
        (define b´ (/ α del-gx´))
        (if (> gx´ gx)
            (loop x´ δ´ (/ α 2) gx  grad-gx´ del-gx´ b´)
            (loop x´ δ´ α       gx´ grad-gx´ del-gx´ b´))]))

  (define gx (apply-vector g x))
  (define δ tolerance)
  (define-values (grad-gx del-gx) (grad/del-g x δ #:fv gx))
  (loop x δ α gx grad-gx del-gx (/ α del-gx)))

(define (Gradient-descent)
  (steepest-descent
    (λ (x y)
       (+ (* (- x 1) (- x 1) (exp (- (sqr y))))
        (* y (+ y 2) (exp (- (* 2 (sqr x)))))))
    #(0.1 -1.) 0.1 0.0000006))

(module+ main
  (Gradient-descent))
