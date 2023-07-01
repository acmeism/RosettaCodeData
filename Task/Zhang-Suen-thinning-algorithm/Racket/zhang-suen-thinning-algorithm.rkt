#lang racket
(define (img-01string->vector str)
  (define lines (regexp-split "\n" str))
  (define h (length lines))
  (define w (if (zero? h) 0 (string-length (car lines))))
  (define v (for*/vector #:length (* w h)
              ((l (in-list lines)) (p (in-string l)))
              (match p (#\0 0) (#\1 1) (#\# 1) (#\. 0))))
  (values v h w))

; Task (2) asks for "or an ASCII-art image of space/non-space characters."
; Spaces don't really impress where the borders are, so we'll use a dot.
(define cell->display-char (match-lambda (0 ".") (1 "#") (else "?")))

(define (display-img v w)
  (for ((p (in-vector v)) (col (in-naturals)))
    (printf "~a" (cell->display-char p))
    (when (= (modulo col w) (sub1 w)) (newline))))

; returns vector of ([P1's idx] P1 P2 ... P9)
(define (Pns v w r c)
  (define i (+ c (* r w)))
  (define-syntax-rule (vi+ x) (vector-ref v (+ i x)))
  (define-syntax-rule (vi- x) (vector-ref v (- i x)))
  (vector i (vi+ 0) (vi- w) (vi+ (- 1 w))
          (vi+ 1) (vi+ (+ w 1)) (vi+ w)
          (vi+ (- w 1)) (vi- 1) (vi- (+ w 1))))

; Second argument to in-vector is the start offset;
; We skip offset 0 (idx) and 1 (P1)
(define (B Ps) (for/sum ((Pn (in-vector Ps 2))) Pn))

(define (A Ps)
  (define P2 (vector-ref Ps 2))
  (define-values (rv _)
    (for/fold ((acc 0) (Pn-1 P2))
      ((Pn (in-sequences (in-vector Ps 3) (in-value P2))))
      (values (+ acc (if (and (= 0 Pn-1) (= 1 Pn)) 1 0)) Pn)))
  rv)

(define-syntax-rule (not-all-black? Pa Pb Pc) (zero? (* Pa Pb Pc)))
(define (z-s-thin v h w)
  ; return idx when thin necessary, #f otherwise
  (define (thin? Ps n/bour-check-1 n/bour-check-2)
    (match-define (vector idx P1 P2 _ P4 _ P6 _ P8 _) Ps)
    (and (= P1 1) (<= 2 (B Ps) 6) (= (A Ps) 1)
         (n/bour-check-1 P2 P4 P6 P8)
         (n/bour-check-2 P2 P4 P6 P8)
         idx))

  (define (has-white?-246 P2 P4 P6 P8) (not-all-black? P2 P4 P6))
  (define (has-white?-468 P2 P4 P6 P8) (not-all-black? P4 P6 P8))
  (define (has-white?-248 P2 P4 P6 P8) (not-all-black? P2 P4 P8))
  (define (has-white?-268 P2 P4 P6 P8) (not-all-black? P2 P6 P8))
  (define (step-n even-Pn-check-1 even-Pn-check-2)
    (for*/list ((r (in-range 1 (- h 1)))
                (c (in-range 1 (- w 1)))
                (idx (in-value (thin? (Pns v w r c)
                                      even-Pn-check-1
                                      even-Pn-check-2)))
                #:when idx) idx))

  (define (step-1) (step-n has-white?-246 has-white?-468))
  (define (step-2) (step-n has-white?-248 has-white?-268))
  (define (inner-z-s-thin)
    (define changed-list-1 (step-1))
    (for ((idx (in-list changed-list-1))) (vector-set! v idx 0))
    (define changed-list-2 (step-2))
    (for ((idx (in-list changed-list-2))) (vector-set! v idx 0))
    (unless (and (null? changed-list-1) (null? changed-list-2)) (inner-z-s-thin)))
  (inner-z-s-thin))

(define (read-display-thin-display-image img-str)
  (define-values (v h w) (img-01string->vector img-str))
  (printf "Original image:~%") (display-img v w)
  (z-s-thin v h w)
  (printf "Thinned image:~%") (display-img v w))

(define e.g.-image #<<EOS
00000000000000000000000000000000
01111111110000000111111110000000
01110001111000001111001111000000
01110000111000001110000111000000
01110001111000001110000000000000
01111111110000001110000000000000
01110111100000001110000111000000
01110011110011101111001111011100
01110001111011100111111110011100
00000000000000000000000000000000
EOS
  )

(define e.g.-image/2 #<<EOS
##..###
##..###
##..###
##..###
##..##.
##..##.
##..##.
##..##.
##..##.
##..##.
##..##.
##..##.
######.
.......
EOS
  )

(module+ main
  ; (read-display-thin-display-image e.g.-image/2)
  ; (newline)
  (read-display-thin-display-image e.g.-image))
