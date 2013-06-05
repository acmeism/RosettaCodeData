#lang racket

(struct Q (x y) #:transparent)

;; returns true if given q1 and q2 do not conflict
(define (safe? q1 q2)
  (match* (q1 q2)
    [((Q x1 y1) (Q x2 y2))
     (not (or (= x1 x2) (= y1 y2)
              (= (abs (- x1 x2)) (abs (- y1 y2)))))]))

;; returns true if given q doesn't conflict with anything in given list of qs
(define (safe-lst? q qs) (for/and ([q2 qs]) (safe? q q2)))

(define (nqueens n)
  ;; qs is partial solution; x y is current position to try
  (let loop ([qs null] [x 0] [y 0])
    (cond [(= (length qs) n) qs]          ; found a solution
          [(>= x n) (loop qs 0 (add1 y))] ; go to next row
          [(>= y n) #f]                   ; current solution is invalid
          [else
           (define q (Q x y))
           (if (safe-lst? q qs) ; is current position safe?
               (or (loop (cons q qs) 0 (add1 y)) ; optimistically place a queen
                                                 ; (and move pos to next row)
                   (loop qs (add1 x) y))  ; backtrack if it fails
               (loop qs (add1 x) y))])))

(nqueens 8)
; => (list (Q 3 7) (Q 1 6) (Q 6 5) (Q 2 4) (Q 5 3) (Q 7 2) (Q 4 1) (Q 0 0))
