#lang racket

(require 2htdp/image)

(define SIZE 300)

(define (game-of-chaos fns WIDTH HEIGHT SIZE
                       #:offset-x [offset-x 0] #:offset-y [offset-y 0]
                       #:iters [iters 10000]
                       #:bg [bg 'white] #:fg [fg 'black])
  (define dot (square 1 'solid fg))
  (define all-choices (apply + (map first fns)))
  (for/fold ([image (empty-scene WIDTH HEIGHT bg)]
             [x (random)] [y (random)]
             #:result image)
            ([i (in-range iters)])
    (define picked (random all-choices))
    (define fn (for/fold ([acc 0] [result #f] #:result result) ([fn (in-list fns)])
                 #:break (> acc picked)
                 (values (+ (first fn) acc) (second fn))))
    (match-define (list x* y*) (fn x y))
    (values (place-image dot (+ offset-x (* SIZE x*)) (+ offset-y (* SIZE y*)) image)
            x* y*)))

(define (draw-triangle)
  (define ((mid a b) x y) (list (/ (+ a x) 2) (/ (+ b y) 2)))
  (define (triangle-height x) (* (sqrt 3) 0.5 x))
  (game-of-chaos (list (list 1 (mid 0 0))
                       (list 1 (mid 1 0))
                       (list 1 (mid 0.5 (triangle-height 1))))
                 SIZE (triangle-height SIZE) SIZE))

(define (draw-fern)
  (define (f1 x y) (list 0 (* 0.16 y)))
  (define (f2 x y) (list (+ (* 0.85 x) (* 0.04 y)) (+ (* -0.04 x) (* 0.85 y) 1.6)))
  (define (f3 x y) (list (+ (* 0.2 x) (* -0.26 y)) (+ (* 0.23 x) (* 0.22 y) 1.6)))
  (define (f4 x y) (list (+ (* -0.15 x) (* 0.28 y)) (+ (* 0.26 x) (* 0.24 y) 0.44)))
  (game-of-chaos (list (list 1 f1) (list 85 f2) (list 7 f3) (list 7 f4))
                 (/ SIZE 2) SIZE (/ SIZE 11) #:offset-x 70 #:offset-y 10
                 #:bg 'black #:fg 'white))

(define (draw-dragon)
  (game-of-chaos
   (list (list 1 (λ (x y) (list (+ (* 0.5 x) (* -0.5 y)) (+ (* 0.5 x) (* 0.5 y)))))
         (list 1 (λ (x y) (list (+ (* -0.5 x) (* 0.5 y) 1) (+ (* -0.5 x) (* -0.5 y))))))
   SIZE (* 0.8 SIZE) (/ SIZE 1.8) #:offset-x 64 #:offset-y 120))

(draw-triangle)
(draw-fern)
(draw-dragon)
