#lang lazy
(require racket/class
         "minimax.rkt"
         (only-in racket/list shuffle argmax))

(provide game%
         interactive-player
         define-partners)

;;--------------------------------------------------------------------
;; Class representing the logics and optimal strategy
;; for a zero-sum game with perfect information.
(define game%
  (class object%
    (super-new)

    ;; virtual methods which set up the game rules
    (init-field my-win?         ; State -> Bool
                my-loss?        ; State -> Bool
                draw-game?      ; State -> Bool
                my-move         ; State Move -> State
                opponent-move   ; State Move -> State
                possible-moves  ; State -> (list Move)
                show-state)     ; State -> Any

    ;; optimal-move :: State -> Move
    ;; Choses the optimal move.
    ;; If several equivalent moves exist -- choses one randomly.
    (define/public ((optimal-move look-ahead) S)
      (! (argmax (λ (m) (! (minimax (game-tree S m look-ahead))))
                 (shuffle (possible-moves S)))))

    ;; game-tree :: State -> (Move -> (Treeof Real))
    (define (game-tree S m look-ahead)
      (let new-ply ([moves (cycle opponent-move my-move)]
                    [i 1]
                    [s (my-move S m)])
        (cond
          [(my-win? s)        (/  1 i)] ; more close wins and loses
          [(my-loss? s) (/ -1 i)] ; have bigger weights
          [(draw-game? s)     0]
          [(>= i look-ahead)  (/ 1 i)]
          [else (map (λ (x) (new-ply (cdr moves) (+ 1 i) ((car moves) s x)))
                     (possible-moves s))])))

    ;; make-move :: State (State -> Move) -> (Move State Symbol)
    (define/public (make-move S move)
      (cond
        [(my-loss? S)   (values '() S 'loss)]
        [(draw-game? S) (values '() S 'draw)]
        [else (let* ([m* (! (move S))]
                     [S* (my-move S m*)])
                (cond
                  [(my-win? S*)    (values m* S* 'win)]
                  [(draw-game? S*) (values m* S* 'draw)]
                  [else            (values m* S* 'next)]))]))))

;;--------------------------------------------------------------------
;; Mixin representing an interactive game player.
;; The parameter `game` defines a game which is played.
(define (interactive-player game)
  (class game
    (super-new)

    (inherit-field show-state)
    (inherit make-move optimal-move)

    (init-field name
                [look-ahead 4]
                [opponent 'undefined]
                [move-method (optimal-move look-ahead)])

    (define/public (your-turn S)
      (define-values (m S* status) (make-move S move-method))
      (! (printf "\n~a makes move ~a\n" name m))
      (! (show-state S*))
      (! (case status
           ['stop (displayln "The game was interrupted.")]
           ['win  (printf "~a wins!" name)]
           ['loss (printf "~a wins!" name)]
           ['draw (printf "Draw!")]
           [else (send opponent your-turn S*)])))))


;;--------------------------------------------------------------------
;; a simple macro for initialization of game partners
(define-syntax-rule
  (define-partners game (A #:win A-wins #:move A-move)
                        (B #:win B-wins #:move B-move))
  (begin
    (define A (class game
                (super-new
                 [my-win?  A-wins]
                 [my-loss? B-wins]
                 [my-move  A-move]
                 [opponent-move B-move])))
    (define B (class game
                (super-new
                 [my-win?  B-wins]
                 [my-loss? A-wins]
                 [my-move  B-move]
                 [opponent-move A-move])))))

;;--------------------------------------------------------------------
;; the main procedure which initiates the game
(define (start-game p1 p2 initial-state)
  (set-field! opponent p1 p2)
  (set-field! opponent p2 p1)
  (send p1 your-turn initial-state))
