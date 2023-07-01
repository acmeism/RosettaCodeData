#lang racket
(require racket/fixnum)
(define t (make-parameter 100))

(define (Rn v)
  (define (inner-Rn rv idx b-1)
    (define b (fxvector-ref v idx))
    (define rv+ (if (and (= b 1) (= b-1 0)) (add1 rv) rv))
    (if (zero? idx) rv+ (inner-Rn rv+ (sub1 idx) b)))
  (inner-Rn 0 (sub1 (fxvector-length v)) 0))

(define ((make-random-bit-vector p) n)
  (for/fxvector
   #:length n ((i n))
   (if (<= (random) p) 1 0)))

(define (Rn/n l->p n) (/ (Rn (l->p n)) n))

(for ((p (in-list '(1/10 3/10 1/2 7/10 9/10))))
  (define l->p (make-random-bit-vector p))
  (define Kp (* p (- 1 p)))
  (printf "p = ~a\tK(p) =\t~a\t~a~%" p Kp (real->decimal-string Kp 4))
  (for ((n (in-list '(10 100 1000 10000))))
    (define sum-Rn/n (for/sum ((i (in-range (t)))) (Rn/n l->p n)))
    (define sum-Rn/n/t (/ sum-Rn/n (t)))
    (printf "mean(R_~a/~a) =\t~a\t~a~%"
            n n sum-Rn/n/t (real->decimal-string sum-Rn/n/t 4)))
  (newline))

(module+ test
  (require rackunit)
  (check-eq? (Rn (fxvector 1 1 0 0 0 1 0 1 1 1)) 3))
