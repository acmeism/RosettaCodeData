#lang racket
(define << arithmetic-shift)
(define bwbs? bitwise-bit-set?)
;; 1,2,2,3,3,3,4,4,4,4,5,5,5,5,5
;; OEIS: A002024: n appears n times
(define (A002024 n) (exact-floor (+ 1/2 (sqrt (* n 2)))))
;; 1, 1, 2, 1, 2, 3, 1, 2, 3, 4
;; OEIS: A002260: Triangle T(n,k) = k for k = 1..n.
(define (A002260 n) (+ 1 (A002262 (sub1 n))))
;; OEIS: A000217: Triangular numbers: a(n) = C(n+1,2) = n(n+1)/2 = 0+1+2+...+n.
(define (tri n) (* n (sub1 n) 1/2))
;; OEIS: A002262: Triangle read by rows: T(n,k)
(define (A002262 n)
  (define trinv (exact-floor (/ (+ 1 (sqrt (+ 1 (* n 8)))) 2)))
  (- n (/ (* trinv (- trinv 1)) 2)))
(define row-number A002024)
(define col-number A002260)
(define (r.c->n r c) (and (<= 1 r 5) (<= 1 c r) (+ 1 (tri r) (- c 1))))

(define (available-jumps n) ; takes a peg number, and returns a list of (jumped-peg . landing-site)
  (define r (row-number n))
  (define c (col-number n))
  ;; Six possible directions - although noone gets all six: "J" - landing site, "j" jumped peg
  ;;   Triangle   Row/column (square edge)
  ;;    A . B     A.B
  ;;   . a b      .ab
  ;;  C c X d D   CcXdD
  ;; . . e f      ..ef
  ;;. . E . F     ..E.F
  (define (N+.n+ r+ c+) (cons (r.c->n (+ r (* 2 r+)) (+ c (* 2 c+))) (r.c->n (+ r r+) (+ c c+))))
  (define-values (A.a B.b C.c D.d E.e F.f)
    (values (N+.n+ -1 -1) (N+.n+ -1 0) (N+.n+ 0 -1) (N+.n+ 0 1) (N+.n+ 1 0) (N+.n+ 1 1)))
  (filter car (list A.a B.b C.c D.d E.e F.f)))

(define (available-jumps/bits n0)
  (for/list ((A.a (available-jumps (add1 n0))))
    (match-define (cons (app sub1 A) (app sub1 a)) A.a)
    (list A a (bitwise-ior (<< 1 n0) (<< 1 A) (<< 1 a))))) ; on a hop, these three bits will flip

(define avalable-jumps-list/bits (for/vector #:length 15 ((bit 15)) (available-jumps/bits bit)))

;; OK -- we'll be complete about this (so it might take a little longer)
;;
;; There are 2^15 possible start configurations; so we'll just systematically go though them, and
;; build an hash of what can go where. Bits are numbered from 0 - peg#1 to 14 - peg#15.
;; It's overkill for finding a single solution, but it seems that Joe Nord needs a lot of questions
;; answered (which should be herein).
(define paths# (make-hash))
(for* ((board (in-range 0 (expt 2 15)))
       (peg (in-range 15))
       #:when (bwbs? board peg)
       (Jjf (in-list (vector-ref avalable-jumps-list/bits peg)))
       #:when (bwbs? board (second Jjf)) ; need something to jump
       #:unless (bwbs? board (first Jjf))) ; need a clear landing space
  (define board- (bitwise-xor board (third Jjf)))
  (hash-update! paths# board (λ (old) (cons (cons board- Jjf) old)) null))

(define (find-path start end (acc null))
  (if (= start end) (reverse acc)
      (for*/first
          ((hop (hash-ref paths# start null))
           (inr (in-value (find-path (car hop) end (cons hop acc)))) #:when inr) inr)))

(define (display-board board.Jjf)
  (match-define (list board (app add1 J) (app add1 j) _) board.Jjf)
  (printf "~a jumps ~a ->" J j)
  (for* ((r (in-range 1 6))
         (c (in-range 1 (add1 r)))
         (n (in-value (r.c->n r c))))
    (when (= c 1) (printf "~%~a" (make-string (quotient (* 5 (- 5 r)) 2) #\space)))
    (printf "[~a] " (~a #:width 2 #:pad-string " " #:align 'right (if (bwbs? board (sub1 n)) n ""))))
  (newline))

(define (flip-peg p b) (bitwise-xor (<< 1 (sub1 p)) b))
(define empty-board #b000000000000000)
(define full-board  #b111111111111111)

;; Solve #1 missing -> #13 left alone
(for-each display-board (find-path (flip-peg 1 full-board) (flip-peg 13 empty-board)))
