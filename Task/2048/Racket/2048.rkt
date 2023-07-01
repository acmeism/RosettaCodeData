;; LICENSE: See License file LICENSE (MIT license)
;;
;; Repository: https://github.com/danprager/2048
;;
;; Copyright 2014: Daniel Prager
;;                 daniel.a.prager@gmail.com
;;
;; This is a largely clean-room, functional implementation in Racket
;; of the game 2048 by Gabriele Cirulli, based on 1024 by Veewo Studio,
;; and conceptually similar to Threes by Asher Vollmer.
;;
;;
;; HOW TO PLAY:
;;   * Use your arrow keys to slide the tiles.
;;   * When two tiles with the same number touch, they merge into one!
;;   * Press <space> to rotate the board.
;;

#lang racket

(require rackunit
         2htdp/image
         (rename-in 2htdp/universe
                    [left left-arrow]
                    [right right-arrow]
                    [up up-arrow]
                    [down down-arrow]))


(define *side* 4)              ; Side-length of the grid
(define *time-limit* #f)       ; Use #f for no time limit, or number of seconds

(define *amber-alert* 60)      ; Time indicator goes orange when less than this number of seconds remaining
(define *red-alert* 10)        ; Time indicator goes red when less than this number of seconds remaining

(define *tile-that-wins* 2048) ; You win when you get a tile = this number
(define *magnification* 2)     ; Scales the game board

(define (set-side! n)
  (set! *side* n))

;;
;; Numbers can be displayed with substiture text. Just edit this table...
;;
(define *text*
  '((0 "")
    (2 "2")))

;; Color scheme
;;
;; From https://github.com/gabrielecirulli/2048/blob/master/style/main.css
;;
(define *grid-color* (color #xbb #xad #xa0))

(define *default-tile-bg-color* (color #x3c #x3a #x32))
(define *default-tile-fg-color* 'white)

(define *tile-bg-colors*
  (map (lambda (x)
         (match-define (list n r g b) x)
         (list n (color r g b)))
       '((0 #xcc #xc0 #xb3)
         (2 #xee #xe4 #xda)
         (4 #xed #xe0 #xc8)
         (8 #xf2 #xb1 #x79)
         (16 #xf5 #x95 #x63)
         (32 #xf6 #x7c #x5f)
         (64 #xf6 #x5e #x3b)
         (128 #xed #xcf #x72)
         (256 #xed #xcc #x61)
         (512 #xed #xc8 #x50)
         (1024 #xed #xc5 #x3f)
         (2048 #xed #xc2 #x2e))))

(define *tile-fg-colors*
  '((0 dimgray)
    (2 dimgray)
    (4 dimgray)
    (8 white)
    (16 white)
    (32 white)
    (64 white)
    (128 white)
    (256 white)
    (512 white)
    (1024 white)
    (2048 white)))

;;--------------------------------------------------------------------
;; Rows may be represented as lists, with 0s representing empty spots.
;;

(define (nonzero? x) (not (zero? x)))

;; Append padding to lst to make it n items long
;;
(define (pad-right lst padding n)
  (append lst (make-list (- n (length lst)) padding)))

;; Slide items towards the head of the list, doubling adjacent pairs
;; when no item is a 0.
;;
;; E.g. (combine '(2 2 2 4 4)) -> '(4 2 8)
;;
(define (combine lst)
  (cond [(<= (length lst) 1) lst]
        [(= (first lst) (second lst))
         (cons (* 2 (first lst)) (combine (drop lst 2)))]
        [else (cons (first lst) (combine (rest lst)))]))

;; Total of new elements introduced by combining.
;;
;; E.g. (combine-total '(2 2 2 4 4)) -> 4 + 8 = 12
;;
(define (combine-total lst)
  (cond [(<= (length lst) 1) 0]
        [(= (first lst) (second lst))
         (+ (* 2 (first lst)) (combine-total (drop lst 2)))]
        [else (combine-total (rest lst))]))

;; Slide towards the head of the list, doubling pairs, 0 are
;; allowed (and slid through), and length is preserved by
;; padding with 0s.
;;
;; E.g. (slide-left '(2 2 2 0 4 4)) -> '(4 2 8 0 0 0)
;;
(define (slide-left row)
  (pad-right (combine (filter nonzero? row)) 0 (length row)))

;; Slide towards the tail of the list:
;;
;; E.g. (slide-right '(2 2 0 0 4 4)) -> '(0 0 0 0 0 4 8)
;;
(define (slide-right row) (reverse (slide-left (reverse row))))


;;--------------------------------------------------------------------
;; We use a sparse representation for transitions in a row.
;;
;; Moves take the form '(value initial-position final-position)
;;
(define (moves-row-left row [last #f] [i 0] [j -1])
  (if (null? row)
      null
      (let ([head (first row)])
        (cond [(zero? head) (moves-row-left (rest row) last (add1 i) j)]
              [(equal? last head)
               (cons (list head i j)
                     (moves-row-left (rest row) #f (add1 i) j))]
              [else (cons (list head i (add1 j))
                          (moves-row-left (rest row) head (add1 i) (add1 j)))]))))

;; Convert a row into the sparse representaiton without any sliding.
;;
;; E.g. (moves-row-none '(0 2 0 4)) -> '((2 1 1) (4 3 3))
;;
(define (moves-row-none row)
  (for/list ([value row]
             [i (in-naturals)]
             #:when (nonzero? value))
    (list value i i)))

;; Reverse all moves so that:
;;
;; '(value initial final) -> '(value (- n initial 1) (- n final 1)
;;
(define (reverse-moves moves n)
  (define (flip i) (- n i 1))
  (map (λ (m)
         (match-define (list a b c) m)
         (list a (flip b) (flip c)))
       moves))

(define (transpose-moves moves)
  (for/list ([m moves])
    (match-define (list v (list a b) (list c d)) m)
    (list v (list b a) (list d c))))

(define (moves-row-right row [n *side*])
  (reverse-moves (moves-row-left (reverse row)) n))

;;--------------------------------------------------------------------
;; Lift the sparse representation for transitions
;; up to two dimensions...
;;
;; '(value initial final) -> '(value (x initial) (x final))
;;
(define (add-row-coord i rows)
  (for/list ([r rows])
    (match-define (list a b c) r)
    (list a (list i b) (list i c))))

(define (transpose lsts)
  (apply map list lsts))

;; Slide the entire grid in the specified direction
;;
(define (left grid)
  (map slide-left grid))

(define (right grid)
  (map slide-right grid))

(define (up grid)
  ((compose transpose left transpose) grid))

(define (down grid)
  ((compose transpose right transpose) grid))

;; Calculate the change to score from sliding the grid left or right.
;;
(define (score-increment grid)
  (apply + (map (λ (row)
                  (combine-total (filter nonzero? row)))
                grid)))

;; Slide the grid in the specified direction and
;; determine the transitions of the tiles.
;;
;; We'll use these operations to animate the sliding of the tiles.
;;
(define (moves-grid-action grid action)
  (let ([n (length (first grid))])
    (apply append
           (for/list ([row grid]
                      [i (in-range n)])
             (add-row-coord i (action row))))))

(define (moves-grid-left grid)
  (moves-grid-action grid moves-row-left))

(define (moves-grid-right grid)
  (moves-grid-action grid moves-row-right))

(define (moves-grid-up grid)
  ((compose transpose-moves moves-grid-left transpose) grid))

(define (moves-grid-down grid)
  ((compose transpose-moves moves-grid-right transpose) grid))

;; Rotating the entire grid doesn't involve sliding.
;; It's a convenience to allow the player to view the grid from a different
;; orientation.
(define (moves-grid-rotate grid)
  (let ([n (length (first grid))])
    (for/list ([item (moves-grid-action grid moves-row-none)])
      (match-define (list v (list i j) _) item)
      (list v (list i j) (list j (- n i 1))))))

;; Chop a list into a list of sub-lists of length n. Used to move from
;; a flat representation of the grid into a list of rows.
;;
;;
(define (chop lst [n *side*])
  (if (<= (length lst) n)
      (list lst)
      (cons (take lst n) (chop (drop lst n) n))))

;; The next few functions are used to determine where to place a new
;; number in the grid...
;;

;; How many zeros in the current state?
;;
(define (count-zeros state)
  (length (filter zero? state)))

;; What is the absolute index of the nth zero in lst?
;;
;; E.g. (index-of-nth-zero '(0 2 0 4) 1 2)) 1) -> 2
;;
(define (index-of-nth-zero lst n)
  (cond [(null? lst) #f]
        [(zero? (first lst))
         (if (zero? n)
             0
             (add1 (index-of-nth-zero (rest lst) (sub1 n))))]
        [else (add1 (index-of-nth-zero (rest lst) n))]))

;; Place the nth zero in the lst with val.
;;
;; E.g. (replace-nth-zero '(0 2 0 4) 1 2)) -> '(0 2 2 4)
;;
(define (replace-nth-zero lst n val)
  (let ([i (index-of-nth-zero lst n)])
    (append (take lst i) (cons val (drop lst (add1 i))))))

;; There's a 90% chance that a new tile will be a two; 10% a four.
;;
(define (new-tile)
  (if (> (random) 0.9) 4 2))

;; Create a random initial game-board with two non-zeros (2 or 4)
;; and the rest 0s.
;;
;; E.g. '(0 0 0 0
;;        0 2 0 0
;;        2 0 0 0
;;        0 0 0 0)
;;
(define (initial-state [side *side*])
  (shuffle (append (list (new-tile) (new-tile))
                   (make-list (- (sqr side) 2) 0))))

;; The game finishes when no matter which way you slide, the board doesn't
;; change.
;;
(define (finished? state [n *side*])
  (let ([grid (chop state n)])
    (for/and ([op (list left right up down)])
      (equal? grid (op grid)))))

;;--------------------------------------------------------------------
;; Graphics
;;
(define *text-size* 30)
(define *max-text-width* 40)
(define *tile-side* 50)
(define *grid-spacing* 5)
(define *grid-side* (+ (* *side* *tile-side*)
                       (* (add1 *side*) *grid-spacing*)))

;; Memoization - caching images takes the strain off the gc
;;
(define-syntax define-memoized
  (syntax-rules ()
    [(_ (f args ...) bodies ...)
     (define f
       (let ([results (make-hash)])
         (lambda (args ...)
           ((λ vals
              (when (not (hash-has-key? results vals))
                (hash-set! results vals (begin bodies ...)))
              (hash-ref results vals))
            args ...))))]))

;; Look-up the (i,j)th element in the flat representation.
;;
(define (square/ij state i j)
  (list-ref state (+ (* *side* i) j)))

;; Linear interpolation between a and b:
;;
;;   (interpolate 0.0 a b) -> a
;;   (interpolate 1.0 a b) -> b
;;
(define (interpolate k a b)
  (+ (* (- 1 k) a)
     (* k b)))

;; Key value lookup with default return - is there an out-of-the-box function
;; for this?
;;
(define (lookup key lst default)
  (let ([value (assoc key lst)])
    (if value (second value) default)))


;; Make a tile without a number on it in the appropriate color.
;;
(define (plain-tile n)
  (square *tile-side*
          'solid
          (lookup n *tile-bg-colors* *default-tile-bg-color*)))

;; Make text for a tile
;;
(define (tile-text n)
  (let* ([t (text (lookup n *text* (number->string n))
                  *text-size*
                  (lookup n *tile-fg-colors* *default-tile-fg-color*))]
         [side (max (image-width t) (image-height t))])
    (scale (if (> side *max-text-width*) (/ *max-text-width* side) 1) t)))

(define-memoized (make-tile n)
  (overlay
   (tile-text n)
   (plain-tile n)))

;; Place a tile on an image of the grid at (i,j)
;;
(define (place-tile/ij tile i j grid-image)
  (define (pos k)
    (+ (* (add1 k) *grid-spacing*)
       (* k *tile-side*)))
  (underlay/xy grid-image (pos j) (pos i) tile))

;; Make an image of the grid from the flat representation
;;
(define *last-state* null) ; Cache the previous grid to avoid
(define *last-grid* null)  ; senseless regeneration

(define (state->image state)
  (unless (equal? state *last-state*)
    (set! *last-grid*
          (for*/fold ([im (square *grid-side* 'solid *grid-color*)])
            ([i (in-range *side*)]
             [j (in-range *side*)])
            (place-tile/ij (make-tile (square/ij state i j))
                           i j
                           im)))
    (set! *last-state* state))
  *last-grid*)

(define *empty-grid-image*
  (state->image (make-list (sqr *side*) 0)))

;; Convert the sparse representation of moves into a single frame in an
;; animation at time k, where k is between 0.0 (start state) and 1.0
;; (final state).
;;
(define (moves->frame moves k)
  (for*/fold ([grid *empty-grid-image*])
    ([m moves])
    (match-define (list value (list i1 j1) (list i2 j2)) m)
    (place-tile/ij (make-tile value)
                   (interpolate k i1 i2) (interpolate k j1 j2)
                   grid)))

;; Animation of simultaneously moving tiles.
;;
(define (animate-moving-tiles state op)
  (let ([grid (chop state)])
    (build-list 9 (λ (i)
                    (λ ()
                      (moves->frame (op grid)
                                    (* 0.1 (add1 i))))))))

;; Animation of a tile appearing in a previously blank square.
;;
(define (animate-appearing-tile state value index)
  (let ([start (state->image state)]
        [tile (make-tile value)]
        [i (quotient index *side*)]
        [j (remainder index *side*)])
    (build-list 4 (λ (m)
                    (λ ()
                      (place-tile/ij (overlay
                                      (scale (* 0.2 (add1 m)) tile)
                                      (plain-tile 0))
                                     i j
                                     start))))))

;;--------------------------------------------------------------
;;
;; The Game
;;

;; an image-procedure is a procedure of no arguments that produces an image

;; a world contains:
;; state is a ?
;; score is a number
;; winning-total is #f or a number, representing the final score <-- is this
;;  necessary?
;; frames is a (list-of image-procedure)
;; start-time is a number, in seconds
(define-struct world (state score winning-total frames start-time) #:transparent)

;; The game is over when any animations have been finished and
;; no more moves are possible.
;;
;; note that winning the game does *not* end the game.
;;
(define (game-over? w)
  (match-define (world state score wt frames start-time) w)
  (and (null? frames) ; Finish animations to reach final state and show the banner
       (or (finished? state)
           (out-of-time? (world-start-time w)))))

;; Is the player out of time?
(define (out-of-time? start-time)
  (and *time-limit* (< (+ start-time *time-limit*) (current-seconds))))

;; Given an arrow key return the operations to change the state and
;; produce the sliding animation.
;;
(define (key->ops a-key)
  (cond
    [(key=? a-key "left")  (list left moves-grid-left)]
    [(key=? a-key "right") (list right moves-grid-right)]
    [(key=? a-key "up")    (list up moves-grid-up)]
    [(key=? a-key "down")  (list down moves-grid-down)]
    [else (list #f #f)]))

;; Respond to a key-press
;;
(define (change w a-key)
  (match-let ([(list op moves-op) (key->ops a-key)]
              [(world st score wt frames start-time) w])
    (cond [(out-of-time? start-time) w] ; Stop accepting key-presses
          [op
           (let* ([grid (chop st)]
                  [slide-state (flatten (op grid))])
             (if (equal? slide-state st)
                 w                       ; sliding had no effect
                 (let* ([replace (random (count-zeros slide-state))]
                        [index (index-of-nth-zero slide-state replace)]
                        [value (new-tile)]
                        [new-state (replace-nth-zero slide-state replace value)]
                        [horizontal? (member a-key (list "left" "right"))])
                   (make-world new-state
                               (+ score (score-increment
                                         (if horizontal? grid (transpose grid))))
                               (cond [wt wt]
                                     [(won-game? new-state)
                                      (apply + (flatten new-state))]
                                     [else #f])
                               (append frames
                                       (animate-moving-tiles st moves-op)
                                       (animate-appearing-tile slide-state value index))
                               start-time))))]
          [(key=? a-key " ")             ; rotate the board
           (make-world ((compose flatten transpose reverse) (chop st))
                       score wt
                       (append frames
                               (animate-moving-tiles st moves-grid-rotate))
                       start-time)]
          [else w])))                    ; unrecognised key - no effect

;; Are we there yet?
;;
(define (won-game? state)
  (= (apply max state) *tile-that-wins*))

;; Banner overlay text: e.g. You won! / Game Over, etc.
;;
(define (banner txt state [color 'black])
  (let ([b-text (text txt 30 color)])
    (overlay
     b-text
     (rectangle (* 1.2 (image-width b-text))
                (* 1.4 (image-height b-text))
                'solid 'white)
     (state->image state))))

;; Convert number of seconds to "h:mm:ss" or "m:ss" format
;;
(define (number->time-string s)
  (define hrs (quotient s 3600))
  (define mins (quotient (remainder s 3600) 60))
  (define secs (remainder s 60))
  (define (xx n)
    (cond [(<= n 0) "00"]
          [(<= n 9) (format "0~a" n)]
          [else (remainder n 60)]))
  (if (>= s 3600)
      (format "~a:~a:~a" hrs (xx mins) (xx secs))
      (format "~a:~a" mins (xx secs))))

(define (time-remaining start)
  (+ *time-limit* start (- (current-seconds))))

(define (time-elapsed start)
  (- (current-seconds) start))

;; Display the grid with score below.
;;
;; If there are frames, show the next one. Otherwise show the steady state.
;;
(define (show-world w)
  (match-define (world state score wt frames start-time) w)
  (let* ([board (if (null? frames)
                    (cond [(finished? state) (banner "Game over" state)]
                          [(out-of-time? start-time) (banner "Out of Time" state 'red)]

                          ;; Q: Why wt (i.e. winning-total) rather than won-game?
                          ;; A: wt allows the keen player to continue playing...
                          [(equal? (apply + (flatten state)) wt) (banner "You won!" state)]
                          [else (state->image state)])
                    ((first frames)))]
         [score-text (text (format "Score: ~a" score) 16 'dimgray)]
         [seconds ((if *time-limit* time-remaining time-elapsed) start-time)]
         [time-text (text (format "Time: ~a"
                                  (number->time-string seconds))
                          16
                          (cond [(or (> seconds *amber-alert*) (not *time-limit*)) 'gray]
                                [(> seconds *red-alert*) 'orange]
                                [else 'red]))])
    (scale *magnification*
           (above
            board
            (rectangle 0 5 'solid 'white)
            (beside
             score-text
             (rectangle (- (image-width board)
                           (image-width score-text)
                           (image-width time-text)) 0 'solid 'white)
             time-text)))))

;; Move to the next frame in the animation.
;;
(define (advance-frame w)
  (match-define (world state score wt frames start-time) w)
  (if (null? frames)
      w
      (make-world state score wt (rest frames) start-time)))

;; Use this state to preview the appearance of all the tiles
;;
(define (all-tiles-state)
  (let ([all-tiles '(0 2 4 8 16 32 64 128 256 512 1024 2048 4096)])
    (append all-tiles (make-list (- (sqr *side*) (length all-tiles)) 0))))

;; The event loop
;;
(define (start)
  (big-bang (make-world (initial-state)
                        ;(all-tiles-state)
                        0 #f null (current-seconds))
            (to-draw show-world)
            (on-key change)
            (on-tick advance-frame 0.01)
            (stop-when game-over? show-world)
            (name "2048 - Racket edition")))

;;
;; TESTS
;;
(module+ test
  (set-side! 4)

  (check-equal? (slide-left '(0 0 0 0)) '(0 0 0 0))
  (check-equal? (slide-left '(1 2 3 4)) '(1 2 3 4))
  (check-equal? (slide-left '(2 0 4 0)) '(2 4 0 0))
  (check-equal? (slide-left '(0 0 2 4)) '(2 4 0 0))
  (check-equal? (slide-left '(2 0 2 0)) '(4 0 0 0))
  (check-equal? (slide-left '(0 8 8 0)) '(16 0 0 0))
  (check-equal? (slide-left '(4 4 8 8)) '(8 16 0 0))
  (check-equal? (slide-right '(4 4 8 8)) '(0 0 8 16))
  (check-equal? (slide-right '(4 4 4 0)) '(0 0 4 8))

  (check-equal? (moves-row-left '(0 0 0 0)) '())
  (check-equal? (moves-row-left '(1 2 3 4))
                '((1 0 0)
                  (2 1 1)
                  (3 2 2)
                  (4 3 3)))

  (check-equal? (moves-row-left '(2 0 4 0)) '((2 0 0)
                                              (4 2 1)))

  (check-equal? (moves-row-right '(2 0 4 0)) '((4 2 3)
                                               (2 0 2)))

  (check-equal? (moves-row-left '(0 0 2 4)) '((2 2 0)
                                              (4 3 1)))

  (check-equal? (moves-row-left '(2 0 2 0)) '((2 0 0)
                                              (2 2 0)))

  (check-equal? (moves-row-left '(2 2 2 0)) '((2 0 0)
                                              (2 1 0)
                                              (2 2 1)))

  (check-equal? (moves-row-right '(2 2 2 0)) '((2 2 3)
                                               (2 1 3)
                                               (2 0 2)))

  (check-equal? (moves-row-left '(2 2 4 4)) '((2 0 0)
                                              (2 1 0)
                                              (4 2 1)
                                              (4 3 1)))

  (check-equal? (moves-row-right '(2 2 4 4)) '((4 3 3)
                                               (4 2 3)
                                               (2 1 2)
                                               (2 0 2)))

  (check-equal? (add-row-coord 7 '((2 0 0)
                                   (2 1 0)
                                   (4 2 1)))
                '((2 (7 0) (7 0))
                  (2 (7 1) (7 0))
                  (4 (7 2) (7 1))))

  (check-equal? (left '(( 0 8 8 0)
                        (16 0 0 0)
                        ( 2 2 4 4)
                        ( 0 2 2 2)))
                '((16 0 0 0)
                  (16 0 0 0)
                  ( 4 8 0 0)
                  ( 4 2 0 0)))
  (check-equal? (right '(( 0 8 8 0)
                         (16 0 0 0)
                         ( 2 2 4 4)
                         ( 0 2 2 2)))
                '((0 0 0 16)
                  (0 0 0 16)
                  (0 0 4  8)
                  (0 0 2  4)))
  (check-equal? (up '((0 16 2 0)
                      (8  0 2 2)
                      (8  0 4 2)
                      (0  0 4 2)))
                '((16 16 4 4)
                  (0  0  8 2)
                  (0  0  0 0)
                  (0  0  0 0)))
  (check-equal? (down '((0 16 2 0)
                        (8  0 2 2)
                        (8  0 4 2)
                        (0  0 4 2)))
                '((0  0  0 0)
                  (0  0  0 0)
                  (0  0  4 2)
                  (16 16 8 4)))

  (check-equal? (left '(( 0 8 8 0)
                        (16 0 0 0)
                        ( 2 2 4 4)
                        ( 0 2 2 2)))
                '((16 0 0 0)
                  (16 0 0 0)
                  ( 4 8 0 0)
                  ( 4 2 0 0)))

  (check-equal? (moves-grid-left '(( 0 8 8 0)
                                   (16 0 0 0)
                                   ( 2 2 4 4)
                                   ( 0 2 2 2)))
                '((8  (0 1) (0 0))
                  (8  (0 2) (0 0))
                  (16 (1 0) (1 0))
                  (2  (2 0) (2 0))
                  (2  (2 1) (2 0))
                  (4  (2 2) (2 1))
                  (4  (2 3) (2 1))
                  (2  (3 1) (3 0))
                  (2  (3 2) (3 0))
                  (2  (3 3) (3 1))))

  (check-equal? (moves-grid-right '(( 0 8 8 0)
                                    (16 0 0 0)
                                    ( 2 2 4 4)
                                    ( 0 2 2 2)))
                '((8  (0 2) (0 3))
                  (8  (0 1) (0 3))
                  (16 (1 0) (1 3))
                  (4  (2 3) (2 3))
                  (4  (2 2) (2 3))
                  (2  (2 1) (2 2))
                  (2  (2 0) (2 2))
                  (2  (3 3) (3 3))
                  (2  (3 2) (3 3))
                  (2  (3 1) (3 2))))


  (check-equal? (moves-grid-up '(( 0 8 8 0)
                                 (16 0 0 0)
                                 ( 2 2 4 4)
                                 ( 0 2 2 2)))
                '((16 (1 0) (0 0))
                  (2  (2 0) (1 0))
                  (8  (0 1) (0 1))
                  (2  (2 1) (1 1))
                  (2  (3 1) (1 1))
                  (8  (0 2) (0 2))
                  (4  (2 2) (1 2))
                  (2  (3 2) (2 2))
                  (4  (2 3) (0 3))
                  (2  (3 3) (1 3))))

  (check-equal? (moves-grid-down '(( 0 8 8 0)
                                   (16 0 0 0)
                                   ( 2 2 4 4)
                                   ( 0 2 2 2)))
                '((2  (2 0) (3 0))
                  (16 (1 0) (2 0))
                  (2  (3 1) (3 1))
                  (2  (2 1) (3 1))
                  (8  (0 1) (2 1))
                  (2  (3 2) (3 2))
                  (4  (2 2) (2 2))
                  (8  (0 2) (1 2))
                  (2  (3 3) (3 3))
                  (4  (2 3) (2 3))))

  (check-equal? (chop '(1 2 3 4 5 6 7 8) 4)
                '((1 2 3 4) (5 6 7 8)))

  (check-equal? (length (initial-state 5)) 25)

  (let* ([initial (initial-state)]
         [initial-sum (apply + initial)]
         [largest-3 (take (sort initial >) 3)])
    (check-equal? (length initial) 16)
    (check-true (or (= initial-sum 4)
                    (= initial-sum 6)
                    (= initial-sum 8)))
    (check-true (or (equal? largest-3  '(2 2 0))
                    (equal? largest-3  '(4 2 0))
                    (equal? largest-3  '(4 4 0)))))

  (check-equal? (count-zeros '(1 0 1 0 0 0 1)) 4)
  (check-equal? (count-zeros '(1 1)) 0)
  (check-equal? (replace-nth-zero '(0 0 0 1 2 0) 2 5)
                '(0 0 5 1 2 0))

  (check-true (finished? '(1 2 3 4) 2))
  (check-false (finished? '(2 2 3 4) 2)))

(start)
