#lang racket

(require "game.rkt"
         racket/set
         lazy/force)

;;--------------------------------------------------------------------
;; Tick-tack-toe game implementation

;; the structure representing a board
(struct board (x o))

;; sets of X's and O's
(define xs board-x)
(define os board-o)

(define empty-board (board (set) (set)))

(define all-cells
  (set '(1 1) '(1 2) '(1 3)
       '(2 1) '(2 2) '(2 3)
       '(3 1) '(3 2) '(3 3)))

(define (free-cells b)
  (set-subtract all-cells (xs b) (os b)))

(define winning-positions
  (list (set '(1 1) '(2 2) '(3 3))
        (set '(1 3) '(2 2) '(3 1))
        (set '(1 1) '(1 2) '(1 3))
        (set '(2 1) '(2 2) '(2 3))
        (set '(3 1) '(3 2) '(3 3))
        (set '(1 1) '(2 1) '(3 1))
        (set '(1 2) '(2 2) '(3 2))
        (set '(1 3) '(2 3) '(3 3))))

;; a predicate for winning state on the board
(define ((wins? s) b)
  (ormap (curryr subset? (s b)) winning-positions))

;; player moves
(define (x-move b m)  (board (set-add (xs b) m) (os b)))
(define (o-move b m)  (board (xs b) (set-add (os b) m)))

;; textual representation of the board
(define (show-board b)
  (for ([i '(3 2 1)])
    (printf "~a " i)
    (for ([j '(1 2 3)])
      (display (cond
                 [(set-member? (os b) (list j i)) "|o"]
                 [(set-member? (xs b) (list j i)) "|x"]
                 [else "| "])))
    (display "|\n"))
  (display "   1 2 3    "))

;;--------------------------------------------------------------------
;; The definition of the game
;; general properties
(define tic-tac%
  (class game%
    (super-new
     [draw-game?       (compose set-empty? free-cells)]
     [possible-moves   (compose set->list free-cells)]
     [show-state       show-board])))

;; players
(define-partners tic-tac%
  (x% #:win (wins? xs) #:move x-move)
  (o% #:win (wins? os) #:move o-move))

;; Computer players
(define player-A (new (interactive-player x%) [name "A"] [look-ahead 6]))

(define player-B (new (interactive-player o%) [name "B"] [look-ahead 6]))

; The interactive user
(define User
  (new (interactive-player x%)
       [name "User"]
       [move-method
        (λ (b) (let make-move ([m (read)])
                 (match m
                   ['q (exit)]
                   [(list (or 1 2 3) (or 1 2 3)) m]
                   [else (make-move (read))])))]))

;; The dummy player plays randomly
(define Dummy
  (new (interactive-player o%) [name "Dummy"] [look-ahead 0]))
