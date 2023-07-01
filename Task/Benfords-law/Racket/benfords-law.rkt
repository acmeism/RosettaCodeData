#lang racket

(define (log10 n) (/ (log n) (log 10)))

(define (first-digit n)
  (quotient n (expt 10 (inexact->exact (floor (log10 n))))))

(define N 10000)

(define fibs
  (let loop ([n N] [a 0] [b 1])
    (if (zero? n) '() (cons b (loop (sub1 n) b (+ a b))))))

(define v (make-vector 10 0))
(for ([n fibs])
  (define f (first-digit n))
  (vector-set! v f (add1 (vector-ref v f))))

(printf "N   OBS   EXP\n")
(define (pct n) (~r (* n 100.0) #:precision 1 #:min-width 4))
(for ([i (in-range 1 10)])
  (printf "~a: ~a% ~a%\n" i
          (pct (/ (vector-ref v i) N))
          (pct (log10 (+ 1 (/ i))))))

;; Output:
;; N   OBS   EXP
;; 1: 30.1% 30.1%
;; 2: 17.6% 17.6%
;; 3: 12.5% 12.5%
;; 4:  9.7%  9.7%
;; 5:  7.9%  7.9%
;; 6:  6.7%  6.7%
;; 7:  5.8%  5.8%
;; 8:  5.1%  5.1%
;; 9:  4.6%  4.6%
