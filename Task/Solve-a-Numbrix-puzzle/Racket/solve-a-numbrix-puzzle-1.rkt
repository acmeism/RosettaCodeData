#lang racket
;;; Used in my solutions of:
;;; "Solve a Hidato Puzzle"
;;; "Solve a Holy Knights Tour"
;;; "Solve a Numbrix Puzzle"
;;; "Solve a Hopido Puzzle"

;;; As well as the solver being common, the solution renderer and input formats are common
(provide
 ;; Input:  list of neighbour offsets
 ;; Output: a solver function:
 ;;         Input:  a puzzle
 ;;         Output: either the solved puzzle or #f if impossible
 solve-hidato-family
 ;; Input:  puzzle
 ;;         optional minimum cell width
 ;; Output: a pretty string that can be printed
 puzzle->string)

;; Cell values are:
;; zero?     - unvisited
;; positive? - nth visitied
;; else      - unvisitable. In the puzzle layout, it's a _. In the hash it's a -1, so we can care less
;;                          about number type checking.
;; A puzzle is a sequence of sequences of cell values
;; We work with a puzzle as a hash keyed on (cons row-num col-num)

;; Take a puzzle and get a working hash of it
(define (puzzle->hash p)
  (for*/hash
      (((r row-num) (in-parallel p (in-naturals)))
       ((v col-num) (in-parallel r (in-naturals)))
       #:when (integer? v))
    (values (cons row-num col-num) v)))

;; Takes a hash and recreates a vector of vectors puzzle
(define (hash->puzzle h# (blank '_))
  (define keys (hash-keys h#))
  (define n-rows (add1 (car (argmax car keys))))
  (define n-cols (add1 (cdr (argmax cdr keys))))
  (for/vector #:length n-rows ((r n-rows))
    (for/vector #:length n-cols ((c n-cols))
      (hash-ref h# (cons r c) blank))))

;; See "provide" section for description
(define (puzzle->string p (w #f))
  (match p
    [#f "unsolved"]
    [(? sequence? s)
     (define (max-n-digits p)
       (and p (add1 (order-of-magnitude (* (vector-length p) (vector-length (vector-ref p 0)))))))
     (define min-width (or w (max-n-digits p)))
     (string-join
      (for/list ((r s))
        (string-join
         (for/list ((c r)) (~a c #:align 'right #:min-width min-width))
         " "))
      "\n")]))

(define ((solve-hidato-family neighbour-offsets) board)
  (define board# (puzzle->hash board))
  ;; reverse mapping, will only take note of positive values
  (define targets# (for/hash ([(k v) (in-hash board#)] #:when (positive? v)) (values v k)))

  (define (neighbours r.c)
    (for/list ((r+.c+ neighbour-offsets))
      (match-define (list r+ c+) r+.c+)
      (match-define (cons r  c ) r.c)
      (cons (+ r r+) (+ c c+))))

  ;; Count the moves, rather than check for "no more zeros" in puzzle
  (define last-move (length (filter number? (hash-values board#))))

  ;; Depth first solution of the puzzle (we have to go deep, it's where the solutions are!
  (define (inr-solve-pzl b# move r.c)
    (cond
      [(= move last-move) b#] ; no moves needed, so solved
      [else
       (define m++ (add1 move))
       (for*/or ; check each neighbour as an option
           ((r.c+ (in-list (neighbours r.c)))
            #:when (equal? (hash-ref targets# move r.c) r.c) ; we're where we should be!
            #:when (match (hash-ref b# r.c+ -1) (0 #t) ((== m++) #t) (_ #f)))
         (inr-solve-pzl (hash-set b# r.c+ m++) m++ r.c+))]))

  (define (solution-starting-at n)
    (define start-r.c (for/first (((k v) (in-hash board#)) #:when (= n v)) k))
    (and start-r.c (inr-solve-pzl board# n start-r.c)))

  (define sltn
    (cond [(solution-starting-at 1) => values]
          ;; next clause starts from 0 for hopido
          [(solution-starting-at 0) => values]))

  (and sltn (hash->puzzle sltn)))
