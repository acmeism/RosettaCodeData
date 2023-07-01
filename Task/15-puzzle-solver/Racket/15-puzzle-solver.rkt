#lang racket

;;; Solution to the 15-puzzle game, based on the A* algorithm described
;;; at https://de.wikipedia.org/wiki/A*-Algorithmus

;;; Inspired by the Python solution of the rosetta code:
;;; http://rosettacode.org/wiki/15_puzzle_solver#Python

(require racket/set)
(require data/heap)

;; ----------------------------------------------------------------------------
;; Datatypes

;; A posn is a pair struct containing two integer for the row/col indices.
(struct posn (row col) #:transparent)

;; A state contains a vector and a posn describing the position of the empty slot.
(struct state (matrix empty-slot) #:transparent)

(define directions '(up down left right))

;; A node contains a state, a reference to the previous node, a g value (actual
;; costs until this node, and a f value (g value + heuristics).
(struct node (state prev cost f-value) #:transparent)

;; ----------------------------------------------------------------------------
;; Constants

(define side-size 4)

(define initial-state
  (state
    #(
      15  14  1  6
      9  11  4 12
      0  10  7  3
      13  8  5  2)
    (posn 2 0)))


(define goal-state
  (state
    #( 1  2  3  4
      5  6  7 8
      9 10 11 12
      13 14 15 0)
    (posn 3 3)))

;; ----------------------------------------------------------------------------
;; Functions

;; Matrices are simple vectors, abstracted by following functions.
(define (matrix-ref matrix row col)
  (vector-ref matrix (+ (* row side-size) col)))

(define (matrix-set! matrix row col val)
  (vector-set! matrix
               (+ (* row side-size) col)
               val))

(define (target-state? st)
  (equal? st goal-state))

;; Traverse all nodes until the initial state and generate a return a list
;; of symbols describing the path.
(define (reconstruct-movements leaf-node)
  ;; compute a pair describing the movement.
  (define (posn-diff p0 p1)
    (posn (- (posn-row p1) (posn-row p0))
          (- (posn-col p1) (posn-col p0))))

  ;; describe a single movement with a symbol (r, l, u d).
  (define (find-out-movement prev-st st)
    (let ([prev-empty-slot (state-empty-slot prev-st)]
          [this-empty-slot (state-empty-slot st)])
      (match (posn-diff prev-empty-slot this-empty-slot)
             [(posn  1  0) 'u]
             [(posn -1  0) 'd]
             [(posn  0  1) 'l]
             [(posn  0 -1) 'r]
             [#f 'invalid])))

  (define (iter n path)
    (if (or (not n) (not (node-prev n)))
        path
      (iter (node-prev n)
            (cons (find-out-movement (node-state n)
                                     (node-state (node-prev n)))
                  path))))
  (iter leaf-node '()))

(define (print-path path)
  (for ([dir (in-list (car path))])
       (display dir))
  (newline))

;; Return #t if direction is allowed for the given empty slot position.
(define (movement-valid? direction empty-slot)
  (match direction
         ['up (< (posn-row empty-slot) (- side-size 1))]
         ['down (> (posn-row empty-slot) 0)]
         ['left (< (posn-col empty-slot) (- side-size 1))]
         ['right (> (posn-col empty-slot) 0)]))

;; assumes move direction is valid (see movement-valid?).
;; Return a new state in the given direction.
(define (move st direction)
  (define m (vector-copy (state-matrix st)))
  (define empty-slot (state-empty-slot st))
  (define r (posn-row empty-slot))
  (define c (posn-col empty-slot))
  (define new-empty-slot
    (match direction
           ['up  (begin (matrix-set! m r c (matrix-ref m (+ r 1) c))
                        (matrix-set! m (+ r 1) c 0)
                        (posn (+ r 1) c))]
           ['down (begin (matrix-set! m r c (matrix-ref m (- r 1) c))
                         (matrix-set! m (- r 1) c 0)
                         (posn (- r 1) c))]
           ['left (begin (matrix-set! m r c (matrix-ref m r (+ c 1)))
                         (matrix-set! m r (+ c 1) 0)
                         (posn r (+ c 1)))]
           ['right (begin (matrix-set! m r c (matrix-ref m r (- c 1)))
                          (matrix-set! m r (- c 1) 0)
                          (posn r (- c 1)))]))
  (state m new-empty-slot))

(define (l1-distance posn0 posn1)
  (+ (abs (- (posn-row posn0) (posn-row posn1)))
     (abs (- (posn-col posn0) (posn-col posn1)))))

;; compute the L1 distance from the current position and the goal position for
;; the given val
(define (element-cost val current-posn)
  (if (= val 0)
      (l1-distance current-posn (posn 3 3))
    (let ([target-row (quotient (- val 1) side-size)]
          [target-col (remainder (- val 1) side-size)])
      (l1-distance current-posn (posn target-row target-col)))))

;; compute the l1 distance between this state and the goal-state
(define (state-l1-distance-to-goal st)
  (define m (state-matrix st))
  (for*/fold
    ([sum 0])
    ([i (in-range side-size)]
     [j (in-range side-size)])
    (let ([val (matrix-ref m i j)])
      (if (not (= val 0))
          (+ sum (element-cost val (posn i j)))
        sum))))

;; the heuristic used is the l1 distance to the goal-state + the number of
;; linear conflicts found
(define (state-heuristics st)
  (+ (state-l1-distance-to-goal st)
     (linear-conflicts st goal-state)))

;; given a list, return the number of values out of order (used for computing
;; linear conflicts).
(define (out-of-order-values lst)
  (define (iter val-lst sum)
    (if (empty? val-lst)
        sum
      (let* ([val (car val-lst)]
             [rst (cdr val-lst)]
             [following-smaller-values
               (filter (lambda (val2) (> val2 val))
                       rst)])
        (iter rst (+ sum (length following-smaller-values))))))
  (* 2 (iter lst 0)))

;; Number of conflicts in the given row. A conflict happens, when two elements
;; are already in the correct row, but in the wrong order.
;; For each conflicted pair add 2 to the value, but a maximum of 6.
(define (row-conflicts row st0 st1)
  (define m0 (state-matrix st0))
  (define m1 (state-matrix st1))

  (define values-in-correct-row
    (for/fold
      ([lst '()])
      ([col0 (in-range side-size)])
      (let* ([val0 (matrix-ref m0 row col0)]
             [in-goal-row?
               (for/first ([col1 (in-range side-size)]
                           #:when (= val0 (matrix-ref m1 row col1)))
                          #t)])
        (if in-goal-row? (cons val0 lst) lst))))

  (min 6 (out-of-order-values
           ; 0 doesn't lead to a linear conflict
           (filter positive? values-in-correct-row))))

;; Number of conflicts in the given row. A conflict happens, when two elements
;; are already in the correct column but in the wrong order.
;; For each conflicted pair add 2 to the value, but a maximum of 6, so that
;; the heuristic doesn't overestimate the actual costs.
(define (col-conflicts col st0 st1)
  (define m0 (state-matrix st0))
  (define m1 (state-matrix st1))

  (define values-in-correct-col
    (for/fold
      ([lst '()])
      ([row0 (in-range side-size)])
      (let* ([val0 (matrix-ref m0 row0 col)]
             [in-goal-col?
               (for/first ([row1 (in-range side-size)]
                           #:when (= val0 (matrix-ref m1 row1 col)))
                          #t)])
        (if in-goal-col? (cons val0 lst) lst))))
  (min 6 (out-of-order-values
           ; 0 doesn't lead to a linear conflict
           (filter positive? values-in-correct-col))))

(define (all-row-conflicts st0 st1)
  (for/fold ([sum 0])
            ([row (in-range side-size)])
            (+ (row-conflicts row st0 st1) sum)))

(define (all-col-conflicts st0 st1)
  (for/fold ([sum 0])
            ([col (in-range side-size)])
            (+ (col-conflicts col st0 st1) sum)))

(define (linear-conflicts st0 st1)
  (+ (all-row-conflicts st0 st1) (all-col-conflicts st0 st1)))

;; Return a list of pairs containing the possible next node and the movement
;; direction needed.
(define (next-state-dir-pairs current-node)
  (define st (node-state current-node))
  (define empty-slot (state-empty-slot st))
  (define valid-movements
    (filter (lambda (dir) (movement-valid? dir empty-slot))
            directions))
  (map (lambda (dir)
         (cons (move st dir) dir))
       valid-movements))

;; Helper function to pretty-print a state
(define (display-state st)
  (define m (state-matrix st))
  (begin
    (for ([i (in-range 0 side-size 1)])
         (newline)
         (for ([j (in-range 0 side-size 1)])
              (printf "~a\t" (matrix-ref m i j))))
    (newline)))


(define (A* initial-st)
  (define (compare-nodes n0 n1)
    (<= (node-f-value n0) (node-f-value n1)))
  (define open-lst (make-heap compare-nodes))
  (define initial-st-cost (state-heuristics initial-st))
  (heap-add! open-lst (node initial-st #f 0 (state-heuristics initial-st)))
  (define closed-set (mutable-set))

  (define (pick-next-node!)
    (define next-node (heap-min open-lst))
    (heap-remove-min! open-lst)
    next-node)

  (define (sort-lst lst)
    (sort lst
          (lambda (n0 n1)
            (< (node-f-value n0) (node-f-value n1)))))

  (define (expand-node n)

    (define n-cost (node-cost n))

    (define (iter lst)
      (if (empty? lst)
          '()
        (let* ([succ (car lst)]
               [succ-st (car succ)]
               [succ-dir (cdr succ)]
               [succ-cost (+ 1 n-cost)])
          (if (set-member? closed-set succ-st)
              (iter (cdr lst))

            (begin    (heap-add! open-lst
                                 (node succ-st
                                       n
                                       succ-cost
                                       (+ (state-heuristics succ-st)
                                          succ-cost)))
                   (iter (cdr lst)))))))

    (let ([successors (next-state-dir-pairs n)])
      (iter successors)))

  (define counter 0)
  (define (loop)
    (define current-node (pick-next-node!))
    (define current-state (node-state current-node))
    (set! counter (+ counter 1))
    (if (= (remainder counter 100000) 0)
        (printf "~a ~a ~a\n" counter
                (heap-count open-lst)
                (node-cost current-node))
      (void))

    (cond [(target-state? current-state)
           (let ([path (reconstruct-movements current-node)])
             (cons path (length path)))]
          [else
            (begin (set-add! closed-set (node-state current-node))
                   (expand-node current-node)
                   (if (= (heap-count open-lst) 0)
                       #f
                     (loop)))]))
  (loop))

(module+ main
         (print-path (A* initial-state)))
