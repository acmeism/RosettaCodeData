#lang racket
(define white (match-lambda ['P #\♙] ['R #\♖] ['B #\♗] ['N #\♘] ['Q #\♕] ['K #\♔]))
(define black (match-lambda ['P #\♟] ['R #\♜] ['B #\♝] ['N #\♞] ['Q #\♛] ['K #\♚]))

(define (piece->unicode piece colour)
  (match colour ('w white) ('b black)) piece)

(define (find/set!-random-slot vec val k (f values))
  (define r (f (random k)))
  (cond
    [(vector-ref vec r)
     (find/set!-random-slot vec val k f)]
    [else
     (vector-set! vec r val)
     r]))

(define (chess960-start-position)
  (define v (make-vector 8 #f))
  ;; Kings and Rooks
  (let ((k (find/set!-random-slot v (white 'K) 6 add1)))
    (find/set!-random-slot v (white 'R) k)
    (find/set!-random-slot v (white 'R) (- 7 k) (curry + k 1)))
  ;; Bishops -- so far only three squares allocated, so there is at least one of each colour left
  (find/set!-random-slot v (white 'B) 4 (curry * 2))
  (find/set!-random-slot v (white 'B) 4 (compose add1 (curry * 2)))
  ;; Everyone else
  (find/set!-random-slot v (white 'Q) 8)
  (find/set!-random-slot v (white 'N) 8)
  (find/set!-random-slot v (white 'N) 8)
  (list->string (vector->list v)))

(chess960-start-position)
