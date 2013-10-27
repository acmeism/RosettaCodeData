#lang racket

(require "game.rkt"
         lazy/force)

;;--------------------------------------------------------------------
;; The definition of the game

(define initial-state '(3 5 7))

(define (move s m) (map - s m))

(define (win? s) (= 1 (apply + s)))

(define (show-state s) (displayln (map (λ (n) (make-list n '●)) s)))

(define (possible-moves S)
  (append-map
   (λ (heap n)
     (map (λ (x) (map (curry * x) heap))
          (range 1 (+ 1 (min 3 n)))))
   '((1 0 0) (0 1 0) (0 0 1)) S))

(define Nim% (class game%
               (super-new
                [draw-game?       (const #f)]
                [possible-moves   possible-moves]
                [show-state       show-state])))

(define-partners Nim%
  (first%  #:win win? #:move move)
  (second% #:win win? #:move move))

;; players
(define player-A
  (new (interactive-player first%) [name "A"] [look-ahead 4]))

(define player-B
  (new (interactive-player second%) [name "B"] [look-ahead 4]))
