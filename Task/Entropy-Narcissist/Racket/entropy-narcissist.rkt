#lang racket
(require math)
(define (log2 x) (/ (log x) (log 2)))
(define ds (string->list (file->string "entropy.rkt")))
(define n (length ds))
(- (for/sum ([(d c) (in-hash (samples->hash ds))])
     (* (/ c n) (log2 (/ c n)))))
