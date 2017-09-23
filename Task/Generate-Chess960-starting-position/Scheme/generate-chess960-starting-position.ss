(import (scheme base) (scheme write)
        (srfi 1)    ; list library
        (srfi 27))  ; random numbers

(random-source-randomize! default-random-source)

;; Random integer in [start, end)
(define (random-between start end)
  (let ((len (- end start 1)))
    (if (< len 2)
      start
      (+ start (random-integer len)))))

;; Random item in list
(define (random-pick lst)
  (if (= 1 (length lst))
    (car lst)
    (list-ref lst (random-integer (length lst)))))

;; Construct a random piece placement for Chess960
(define (random-piece-positions)
  (define (free-indices positions) ; return list of empty slot indices
    (let loop ((i 0)
               (free '()))
      (if (= 8 i)
        free
        (loop (+ 1 i)
              (if (string=? "." (vector-ref positions i))
                (cons i free)
                free)))))
  ;
  (define (place-king+rooks positions)
    (let ((king-posn (random-between 1 8)))
      (vector-set! positions king-posn "K")
      ; left-rook is between left-edge and king
      (vector-set! positions (random-between 0 king-posn) "R")
      ; right-rook is between right-edge and king
      (vector-set! positions (random-between (+ 1 king-posn) 8) "R")))
  ;
  (define (place-bishops positions)
    (let-values (((evens odds) (partition even? (free-indices positions))))
                (vector-set! positions (random-pick evens) "B")
                (vector-set! positions (random-pick odds) "B")))
  ;
  (let ((positions (make-vector 8 ".")))
    (place-king+rooks positions)
    (place-bishops positions)
    ;; place the queen in a random remaining slot
    (vector-set! positions (random-pick (free-indices positions)) "Q")
    ;; place the two knights in the remaining slots
    (for-each (lambda (idx) (vector-set! positions idx "N"))
              (free-indices positions))

    positions))

(display "First rank: ") (display (random-piece-positions)) (newline)
