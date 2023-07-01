#lang racket

; Hunt the Wumpus

(require racket/random)

(struct game-state (labyrinth
                    player-location
                    number-of-arrows
                    wumpus-location
                    bat-locations
                    pit-locations) #:mutable #:transparent)

; The labyrinth-data list contains 20 lists that hold the information for
; each rooms connections to other rooms in the labyrinth.
; e.g. (1 2 5 8) shows that room 1 has connections to rooms 2, 5 and 8.

(define labyrinth-data '(
                         (1 2 5 8)
                         (2 1 3 10)
                         (3 2 4 12)
                         (4 3 5 14)
                         (5 1 4 6)
                         (6 5 7 15)
                         (7 6 8 17)
                         (8 1 7 9)
                         (9 8 10 18)
                         (10 2 9 11)
                         (11 10 12 19)
                         (12 3 11 13)
                         (13 12 14 20)
                         (14 4 13 15)
                         (15 6 14 16)
                         (16 15 17 20)
                         (17 7 16 18)
                         (18 9 17 19)
                         (19 11 18 20)
                         (20 13 16 19)))

(define example-game-state (game-state labyrinth-data
                                       1
                                       5
                                       2
                                       '(3 4)
                                       '(5 6)))

(define (new-game-state)
  (let ([ngs (game-state labyrinth-data 1 5 1 '(1 1) '(1 1))])
    (set-game-state-wumpus-location! ngs (safe-empty-room ngs))
    (set-game-state-bat-locations! ngs (list (safe-empty-room ngs)))
    (set-game-state-bat-locations! ngs (cons (safe-empty-room ngs)
                                             (game-state-bat-locations ngs)))
    (set-game-state-pit-locations! ngs (list (safe-empty-room ngs)))
    (set-game-state-pit-locations! ngs (cons (safe-empty-room ngs)
                                             (game-state-pit-locations ngs)))
    ngs))

(define (move-player room current-game-state)
  (set-game-state-player-location! current-game-state room))

(define (disturb-wumpus current-game-state)
  (if (<= (random) 0.75)
      (set-game-state-wumpus-location! current-game-state
                                       (room-for-wumpus-move current-game-state))
      #f))

(define (room-for-wumpus-move current-game-state)
  (let ([choices (append (neighbours
                          (game-state-wumpus-location current-game-state)
                          current-game-state)
                         (list (game-state-wumpus-location current-game-state)))])
    (findf (λ (room) (and (not (pit-room? room current-game-state))
                          (not (bat-room? room current-game-state)))) choices)))

(define (lost? current-game-state)
  (or (= (game-state-player-location current-game-state) (game-state-wumpus-location current-game-state))
      (member (game-state-player-location current-game-state)
              (game-state-pit-locations current-game-state))
      (= 0 (game-state-number-of-arrows current-game-state))))

(define (won? current-game-state)
  (= 0 (game-state-wumpus-location current-game-state)))

(define (shoot-arrow room current-game-state)
  (if (= room (game-state-wumpus-location current-game-state))
      (set-game-state-wumpus-location! current-game-state 0)
      (disturb-wumpus current-game-state))
  (set-game-state-number-of-arrows! current-game-state
                                    (- (game-state-number-of-arrows current-game-state) 1)))

(define (move-player-with-bats current-game-state)
  (set-game-state-player-location! current-game-state (safe-empty-room current-game-state)))

(define (safe-empty-room current-game-state)
  (let ([room (+ 1 (random 20))])
    (if (or (= room (game-state-wumpus-location current-game-state))
            (= room (game-state-player-location current-game-state))
            (member room (game-state-bat-locations current-game-state))
            (member room (game-state-pit-locations current-game-state)))
        (safe-empty-room current-game-state)
        room)))

(define (find-room room-number current-game-state)
  (assoc room-number (game-state-labyrinth current-game-state)))

(define (neighbours room-number current-game-state)
  (rest (find-room room-number current-game-state)))

(define (pit-room? room current-game-state)
  (member room (game-state-pit-locations current-game-state)))

(define (bat-room? room current-game-state)
  (member room (game-state-bat-locations current-game-state)))

(define (nearby? room-number entity-room-number current-game-state)
  (member entity-room-number (neighbours room-number current-game-state)))

(define (any-of-in? of-lst in-lst)
  (for/or ([item of-lst])
    (member item in-lst)))

(define (pit-nearby? room current-game-state)
  (any-of-in? (neighbours room current-game-state) (game-state-pit-locations current-game-state)))

(define (bat-nearby? room current-game-state)
  (any-of-in? (neighbours room current-game-state) (game-state-bat-locations current-game-state)))

(define (wumpus-nearby? room current-game-state)
  (member (game-state-wumpus-location current-game-state) (neighbours room current-game-state)))

(define (resolve-command str-list current-game-state)
  (let ([command (string-upcase (first str-list))]
        [room (string->number (second str-list))])
    (if (nearby? (game-state-player-location current-game-state)
                 room current-game-state)
        (cond [(equal? command "W") (if (bat-room? room current-game-state)
                                        (display-bat-attack current-game-state)
                                        (move-player room current-game-state))]
              [(equal? command "S") (shoot-arrow room current-game-state)]
              [else (displayln "Unknown command")])
        (displayln "You cannot move or shoot there!"))))

(define (display-bat-attack current-game-state)
  (move-player-with-bats current-game-state)
  (display "Argh! A Giant Bat has carried you to room ")
  (displayln (game-state-player-location current-game-state)))

(define (display-hazards current-game-state)
  (when (wumpus-nearby? (game-state-player-location current-game-state) current-game-state)
    (displayln "You smell something nearby."))
  (when (bat-nearby? (game-state-player-location current-game-state) current-game-state)
    (displayln "You hear a rustling."))
  (when (pit-nearby? (game-state-player-location current-game-state) current-game-state)
    (displayln "You feel a cold wind blowing from a nearby cavern.")))

(define (display-room-numbers lst)
  (display (string-join (map number->string lst) ", " #:before-last " or " #:after-last ".")))

(define (display-lost-message current-game-state)
  (cond [(= (game-state-player-location current-game-state)
            (game-state-wumpus-location current-game-state)) (displayln "The Wumpus has eaten you!")]
        [(member (game-state-player-location current-game-state)
                 (game-state-pit-locations current-game-state)) (displayln "You have fallen down a pit!")]
        [(= 0 (game-state-number-of-arrows current-game-state)) (displayln "You have run out of arrows.")]
        [else (displayln "Unknown loss")]))

(define (display-won-message current-game-state)
  (displayln "Congratulations, you have slain the Wumpus!"))

(define (display-information current-game-state)
  (display "You can (W)alk or (S)hoot to rooms ")
  (display-room-numbers (neighbours (game-state-player-location current-game-state) current-game-state))
  (newline)
  (display "You have ")
  (display (game-state-number-of-arrows current-game-state))
  (displayln " arrows left.")
  (display-hazards current-game-state))

(define (debug-game-state current-game-state)
  (display "    Player Location : ")
  (displayln (game-state-player-location current-game-state))
  (display "    Wumpus Location : ")
  (displayln (game-state-wumpus-location current-game-state))
  (display "    Bat Locations : ")
  (displayln (game-state-bat-locations current-game-state))
  (display "    Pit Locations : ")
  (displayln (game-state-pit-locations current-game-state)))

(define (game-loop current-game-state)
  ;(debug-game-state current-game-state)
  (display-information current-game-state)
  (resolve-command (string-split (read-line)) current-game-state)
  (cond [(lost? current-game-state) (display-lost-message current-game-state)]
        [(won? current-game-state) (display-won-message current-game-state)]
        [else (game-loop current-game-state)]))

(define (start-game)
  (let ([current-game-state (new-game-state)])
    (game-loop current-game-state)))
