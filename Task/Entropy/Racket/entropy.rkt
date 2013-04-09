#lang racket
(require math)

(define (log2 x)
  (/ (log x) (log 2)))

(define (digits x)
  (for/list ([c (number->string x)])
    (- (char->integer c) (char->integer #\0))))

(define (entropy x)
  (define ds (digits x))
  (define n (length ds))
  (- (for/sum ([(d c) (in-hash (samples->hash ds))])
       (* (/ d n) (log2 (/ d n))))))

(entropy 1223334444)
