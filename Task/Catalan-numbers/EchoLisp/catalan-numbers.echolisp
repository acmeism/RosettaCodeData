(lib 'sequences)
(lib 'bigint)
(lib 'math)

;; function definition
(define (C1 n) (/ (factorial (* n 2)) (factorial (1+ n)) (factorial n)))
(for ((i [1 .. 16])) (write (C1 i)))
    → 1 2 5 14 42 132 429 1430 4862 16796 58786 208012 742900 2674440 9694845

;; using a recursive procedure with memoization
(define (C2 n) ;; ( Σ  ...)is the same as (sigma ..)
	(Σ (lambda(i) (* (C2 i) (C2 (- n i 1))))  0 (1- n)))
(remember 'C2 #(1)) ;; first term defined here

(for ((i [1 .. 16])) (write (C2 i)))
    → 1 2 5 14 42 132 429 1430 4862 16796 58786 208012 742900 2674440 9694845


;; using procrastinators = infinite sequence
(define (catalan n acc) (/ (* acc 2 (1- (* 2 n))) (1+ n)))
(define C3 (scanl catalan 1 [1 ..]))
(take C3 15)
    → (1 2 5 14 42 132 429 1430 4862 16796 58786 208012 742900 2674440 9694845)


;; the same, using infix notation
(lib 'match)
(load 'infix.glisp)

(define (catalan n acc) ((2 * acc * ( 2 * n - 1)) / (n + 1)))
(define C3 (scanl catalan 1 [1 ..]))

(take C3 15)
    → (1 2 5 14 42 132 429 1430 4862 16796 58786 208012 742900 2674440 9694845)
;; or
(for ((c C3) (i 15)) (write c))
    → 1 2 5 14 42 132 429 1430 4862 16796 58786 208012 742900 2674440 9694845
