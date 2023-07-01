(import (scheme base)
        (scheme read)
        (scheme write)
        (srfi 27))    ; random numbers

(define *start-position* #(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 #\space))
(random-source-randomize! default-random-source)

;; return a 16-place vector with the tiles randomly shuffled
(define (create-start-position)
  (let ((board (vector-copy *start-position*)))
    (do ((i 0 (+ 1 i))
         (moves (find-moves board) (find-moves board)))
      ((and (>= i 100)
            (not (finished? board)))
       board)
      (make-move board
                 (list-ref moves (random-integer (length moves)))))))

;; return index of space
(define (find-space board)
  (do ((i 0 (+ 1 i)))
    ((equal? #\space (vector-ref board i)) i)))

;; return a list of symbols indicating available moves
(define (find-moves board)
  (let* ((posn (find-space board))
         (row (quotient posn 4))
         (col (remainder posn 4))
         (result '()))
    (when (> row 0) (set! result (cons 'up result)))
    (when (< row 3) (set! result (cons 'down result)))
    (when (> col 0) (set! result (cons 'left result)))
    (when (< col 3) (set! result (cons 'right result)))
    result))

;; make given move - assume it is legal
(define (make-move board move)
  (define (swap posn-1 posn-2)
    (let ((tmp (vector-ref board posn-1)))
      (vector-set! board posn-1 (vector-ref board posn-2))
      (vector-set! board posn-2 tmp)))
  ;
  (let ((posn (find-space board)))
    (case move
      ((left)
       (swap posn (- posn 1)))
      ((right)
       (swap posn (+ posn 1)))
      ((up)
       (swap posn (- posn 4)))
      ((down)
       (swap posn (+ posn 4))))))

(define (finished? board)
  (equal? board *start-position*))

(define (display-board board)
  (do ((i 0 (+ 1 i)))
    ((= i (vector-length board)) (newline))
    (when (zero? (modulo i 4)) (newline))
    (let ((curr (vector-ref board i)))
      (display curr)
      (display (if (and (number? curr)
                        (> curr 9))
                 " "
                 "  ")))))

;; the main game loop
(define (play-game)
  (let ((board (create-start-position)))
    (do ((count 1 (+ count 1))
         (moves (find-moves board) (find-moves board)))
      ((finished? board)
       (display (string-append "\nCOMPLETED PUZZLE in "
                               (number->string count)
                               " moves\n")))
      (display-board board)
      (display "Enter a move: ") (display moves) (newline)
      (let ((move (read)))
        (if (memq move moves)
          (make-move board move)
          (display "Invalid move - try again"))))))

(play-game)
