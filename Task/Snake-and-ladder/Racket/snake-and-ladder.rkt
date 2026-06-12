#lang racket/base

(define portals (hash  4 14  9 31  17 7  20 38  28 84  40 59  51 67  54 34  62 19  63 81  64 60  71 91  87 24  93 73  95 75  99 78))

(define (find-game-winner n-players reroll-on-six? (win values))
  (let turn ((positions-map (for/hash ((p n-players)) (values p 1))) (player 0))
    (newline)
    (let ((die (add1 (random 6)))
          (position (hash-ref positions-map player)))
      (printf "player ~a at ~a rolls ~a: " (add1 player) position die)
      (let* ((try-position (+ position die))
             (new-position
              (cond [(> try-position 100) (display "player can't move beyond the end.") position]
                    [(= try-position 100) (display "player wins!") try-position]
                    [(hash-ref portals try-position #f)
                     => (λ (slide-to)
                          (printf "~a from ~a to ~a." (if (> slide-to try-position) "LADDER" "SNAKE") try-position slide-to)
                          slide-to)]
                    [else (printf "landed on ~a." try-position) try-position])))
          (if (= new-position 100)
              (win (add1 player))
              (turn (hash-set positions-map player new-position)
                    (if (and (= 6 die) reroll-on-six?)
                        (begin0 player (display " [6] rolls again!"))
                        (modulo (add1 player) n-players))))))))

(module+ main
  (find-game-winner 5 #t (λ (p) (printf "~%~%The winner of the game is player #~a" p))))
