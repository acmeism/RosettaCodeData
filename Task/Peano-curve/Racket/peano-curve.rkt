/* Jens Axel Søgaard, 27th December 2018*/
#lang racket
(require metapict metapict/mat)

;;; Turtle State
(define p (pt 0 0))  ; current position
(define d (vec 0 1)) ; current direction
(define c '())       ; line segments drawn so far

;;; Turtle Operations
(define (jump q)    (set! p q))
(define (move q)    (set! c (cons (curve p -- q) c)) (set! p q))
(define (forward x) (move (pt+ p (vec* x d))))
(define (left  a)   (set! d (rot a d)))
(define (right a)   (left (- a)))

;;; Peano
(define (peano n a h)
  (unless (= n 0)
    (right a)
    (peano (- n 1) (- a) h)
    (forward h)
    (peano (- n 1) a h)
    (forward h)
    (peano (- n 1) (- a) h)
    (left a)))

;;; Produce image
(set-curve-pict-size 400 400)
(with-window (window -1 81 -1 82)
  (peano 6 90 3)
  (draw* c))
