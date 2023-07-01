#lang racket/base
(require 2htdp/universe 2htdp/image racket/list racket/match)

(define ((fifteen->pict (finished? #f)) fifteen)
  (for/fold ((i (empty-scene 0 0))) ((r 4))
    (define row
      (for/fold ((i (empty-scene 0 0))) ((c 4))
        (define v (list-ref fifteen (+ (* r 4) c)))
        (define cell
          (if v
              (overlay/align
               "center" "center"
               (rectangle 50 50 'outline (if finished? "white" "blue"))
               (text (number->string v) 30 "black"))
              (rectangle 50 50 'solid (if finished? "white" "powderblue"))))
        (beside i cell)))
    (above i row)))

(define (move-space fifteen direction)
  (define idx (for/first ((i (in-naturals)) (x fifteen) #:unless x) i))
  (define-values (row col) (quotient/remainder idx 4))
  (define dest (+ idx (match direction
                        ['l #:when (> col 0) -1]
                        ['r #:when (< col 3)  1]
                        ['u #:when (> row 0) -4]
                        ['d #:when (< row 3)  4]
                        [else 0])))
    (list-set (list-set fifteen idx (list-ref fifteen dest)) dest #f))

(define (key-move-space fifteen a-key)
  (cond [(key=? a-key "left") (move-space fifteen 'l)]
        [(key=? a-key "right") (move-space fifteen 'r)]
        [(key=? a-key "up") (move-space fifteen 'u)]
        [(key=? a-key "down") (move-space fifteen 'd)]
        [else fifteen]))

(define (shuffle-15 fifteen shuffles)
  (for/fold ((rv fifteen)) ((_ shuffles))
    (move-space rv (list-ref '(u d l r) (random 4)))))

(define fifteen0 '(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 #f))

(define (solved-world? w) (equal? w fifteen0))

(big-bang (shuffle-15 fifteen0 200)
          (name "Fifteen")
          (to-draw (fifteen->pict))
          (stop-when solved-world? (fifteen->pict #t))
          (on-key key-move-space))
