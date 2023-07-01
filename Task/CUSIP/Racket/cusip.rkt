#lang racket
(require srfi/14)

(define 0-char (char->integer #\0))
(define A-char (char->integer #\A))

(define (cusip-value c)
  (cond
    [(char-set-contains? char-set:digit c)
     (- (char->integer c) 0-char)]
    [(char-set-contains? char-set:upper-case c)
     (+ 10 (- (char->integer c) A-char))]
    [(char=? c #\*) 36]
    [(char=? c #\@) 37]
    [(char=? c #\#) 38]))

(define (cusip-check-digit cusip)
  (modulo
   (- 10
      (modulo
       (for/sum
        ((i (sequence-map add1 (in-range 8))) (c (in-string cusip)))
         (let* ((v (cusip-value c)) (v′ (if (even? i) (* v 2) v)))
           (+ (quotient v′ 10) (modulo v′ 10)))) 10)) 10))

(define (CUSIP? s)
  (char=? (string-ref s (sub1 (string-length s)))
          (integer->char (+ 0-char (cusip-check-digit s)))))

(module+ test
  (require rackunit)
  (check-true (CUSIP? "037833100"))
  (check-true (CUSIP? "17275R102"))
  (check-true (CUSIP? "38259P508"))
  (check-true (CUSIP? "594918104"))
  (check-false (CUSIP? "68389X106"))
  (check-true (CUSIP? "68389X105")))
