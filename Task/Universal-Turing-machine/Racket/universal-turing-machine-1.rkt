#lang racket
;;;=============================================================
;;; Due to heavy use of pattern matching we define few macros
;;;=============================================================

(define-syntax-rule (define-m f m ...)
  (define f (match-lambda m ... (x x))))

(define-syntax-rule (define-m* f m ...)
  (define f (match-lambda** m ...)))

;;;=============================================================
;;; The definition of a functional type Tape,
;;; representing infinite tape with O(1) operations:
;;; put, get, shift-right and shift-left.
;;;=============================================================
(struct Tape (the-left-part      ; i-1 i-2 i-3 ...
              the-current-record ; i
              the-right-part))   ; i+1 i+2 i+3 ...

;; the initial record on the tape
(define-m initial-tape
  [(cons h t) (Tape '() h t)])

;; shifts caret to the right
(define (snoc a b) (cons b a))
(define-m shift-right
  [(Tape '() '() (cons h t)) (Tape '() h t)]      ; left end
  [(Tape  l x '()) (Tape (snoc l x) '() '())]     ; right end
  [(Tape  l x (cons h t)) (Tape (snoc l x) h t)]) ; general case

;; shifts caret to the left
(define-m flip-tape [(Tape l x r) (Tape r x l)])

(define shift-left
  (compose flip-tape shift-right flip-tape))

;; returns the current record on the tape
(define-m get [(Tape _ v _) v])

;; writes to the current position on the tape
(define-m* put
  [('() t) t]
  [(v (Tape l _ r)) (Tape l v r)])

;; Shows the list representation of the tape (≤ O(n)).
;; A tape is shown as (... a b c (d) e f g ...)
;; where (d) marks the current position of the caret.

(define (revappend a b) (foldl cons b a))

(define-m show-tape
  [(Tape '() '() '()) '()]
  [(Tape l '() r) (revappend l (cons '() r))]
  [(Tape l v r) (revappend l (cons (list v) r))])

;;;-------------------------------------------------------------------
;;; The Turing Machine interpreter
;;;

;; interpretation of output triple for a given tape
(define-m* interprete
  [((list v 'right S) tape) (list S (shift-right (put v tape)))]
  [((list v 'left S) tape) (list S (shift-left (put v tape)))]
  [((list v 'stay S) tape) (list S (put v tape))]
  [((list S _) tape) (list S tape)])

;; Runs the program.
;; The initial state is set to start.
;; The initial tape is given as a list of records.
;; The initial position is the leftmost symbol of initial record.
(define (run-turing prog t0 start)
  ((fixed-point
    (match-lambda
      [`(,S ,T) (begin
                  (printf "~a\t~a\n" S (show-tape T))
                  (interprete (prog `(,S ,(get T))) T))]))
   (list start (initial-tape t0))))

;; a general fixed point operator
(define ((fixed-point f) x)
  (let F ([x x] [fx (f x)])
    (if (equal? x fx)
        fx
        (F fx (f fx)))))

;; A macro for definition of a Turing-Machines.
;; Transforms to a function which accepts a list of initial
;; tape records as input and returns the tape after stopping.
(define-syntax-rule (Turing-Machine #:start start (a b c d e) ...)
  (λ (l)
    (displayln "STATE\tTAPE")
    ((match-lambda [(list _ t) (flatten (show-tape t))])
     (run-turing
      (match-lambda ['(a b) '(c d e)] ... [x x])
      l start))))
