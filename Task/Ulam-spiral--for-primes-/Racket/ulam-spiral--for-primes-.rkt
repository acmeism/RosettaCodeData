#lang racket
(require (only-in math/number-theory prime?))

(define ((cell-fn n (start 1)) x y)
  (let* ((y (- y (quotient n 2)))
         (x (- x (quotient (sub1 n) 2)))
         (l (* 2 (if (> (abs x) (abs y)) (abs x) (abs y))))
         (d (if (> y x) (+ (* l 3) x y) (- l x y))))
    (+ (sqr (- l 1)) d start -1)))

(define (show-spiral n
                     #:symbol (smb "# ")
                     #:start (start 1)
                     #:space (space (and smb (make-string (string-length smb) #\space))))
  (define top (+ start (sqr n) 1))
  (define cell (cell-fn n start))
  (define print-cell
    (if smb
        (λ (i p?) (display (if p? smb space)))
        (let* ((max-len (string-length (~a (+ (sqr n) start -1))))
               (space (or space (make-string (string-length (~a (+ (sqr n) start -1))) #\_))))
          (λ (i p?)
            (display (if p? (~a #:width max-len i #:align 'right) space))
            (display #\space)))))

  (for* ((y (in-range 1 (add1 n))) #:when (unless (= y 1) (newline)) (x (in-range 1 (add1 n))))
    (define c (cell x y))
    (define p? (prime? c))
    (print-cell c p?))
  (newline))

(show-spiral 9 #:symbol #f)
(show-spiral 10 #:symbol "♞" #:space "♘") ; black are the primes
(show-spiral 50 #:symbol "*" #:start 42)
; for filling giant terminals
; (show_spiral 1001 "*" 42)
