#lang racket/base
(require racket/list)

(struct cell (v x z) #:transparent)

(define (cell-add cx cy)
  (cell (+ (cell-v cx) (cell-v cy))
        (+ (cell-x cx) (cell-x cy))
        (+ (cell-z cx) (cell-z cy))))

(define (cell-sub cx cy)
  (cell (- (cell-v cx) (cell-v cy))
        (- (cell-x cx) (cell-x cy))
        (- (cell-z cx) (cell-z cy))))
