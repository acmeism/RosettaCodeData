#lang racket
;; For: http://rosettacode.org/wiki/Bernoulli_numbers

;; As described in task...
(define (bernoulli.1 n)
  (define A (make-vector (add1 n)))
  (for ((m (in-range 0 (add1 n))))
    (vector-set! A m (/ (add1 m)))
    (for ((j (in-range m (sub1 1) -1)))
      (define new-A_j-1 (* j (- (vector-ref A (sub1 j)) (vector-ref A j))))
      (vector-set! A (sub1 j) new-A_j-1)))
  (vector-ref A 0))

(define (non-zero-bernoulli-indices s)
  (sequence-filter (λ (n) (or (even? n) (= n 1))) s))
(define (bernoulli_0..n B N)
  (for/list ((n (non-zero-bernoulli-indices (in-range (add1 N))))) (B n)))

;; From REXX description / http://mathworld.wolfram.com/BernoulliNumber.html #33
;; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;; bernoulli.2 is for illustrative purposes, binomial is very costly if there is no memoisation
;; (which math/number-theory doesn't do)
(require (only-in math/number-theory binomial))
(define (bernoulli.2 n)
  (for/sum ((k (in-range 0 (add1 n))))
    (* (/ (add1 k))
       (for/sum ((r (in-range 0 (add1 k))))
         (* (expt -1 r) (binomial k r) (expt r n))))))

;; Three things to do:
;; 1. (expt -1 r): is 1 for even r, -1 for odd r... split the sum between those two.
;; 2. splitting the sum might has arithmetic advantages, too. We're using rationals, so the smaller
;;    summations should require less normalisation of intermediate, fractional results
;; 3. a memoised binomial... although the one from math/number-theory is fast, it is (and its
;;    factorials are) computed every time which is redundant
(define kCr-memo (make-hasheq))
(define !-memo (make-vector 1000 #f))
(vector-set! !-memo 0 1) ;; seed the memo
(define (! k)
  (cond [(vector-ref !-memo k) => values]
        [else (define k! (* k (! (- k 1)))) (vector-set! !-memo k k!) k!]))
(define (kCr k r)
  ; If we want (kCr ... r>1000000) we'll have to reconsider this. However, until then...
  (define hash-key (+ (* 1000000 k) r))
  (hash-ref! kCr-memo hash-key (λ () (/ (! k) (! r) (! (- k r))))))

(define (bernoulli.3 n)
  (for/sum ((k (in-range 0 (add1 n))))
    (define k+1 (add1 k))
    (* (/ k+1)
       (- (for/sum ((r (in-range 0 k+1 2))) (* (kCr k r) (expt r n)))
          (for/sum ((r (in-range 1 k+1 2))) (* (kCr k r) (expt r n)))))))

(define (display/align-fractions caption/idx-fmt Bs)
  ;; widths are one more than the order of magnitude
  (define oom+1 (compose add1 order-of-magnitude))
  (define-values (I-width N-width D-width)
    (for/fold ((I 0) (N 0) (D 0))
      ((b Bs) (n (non-zero-bernoulli-indices (in-naturals))))
      (define +b (abs b))
      (values (max I (oom+1 (max n 1)))
              (max N (+ (oom+1 (numerator +b)) (if (negative? b) 1 0)))
              (max D (oom+1 (denominator +b))))))
  (define (~a/w/a n w a) (~a n #:width w #:align a))
  (for ((n (non-zero-bernoulli-indices (in-naturals))) (b Bs))
    (printf "~a ~a/~a~%"
            (format caption/idx-fmt (~a/w/a n I-width 'right))
            (~a/w/a (numerator b) N-width 'right)
            (~a/w/a (denominator b) D-width 'left))))

(module+ main
  (display/align-fractions "B(~a) =" (bernoulli_0..n bernoulli.3 60)))

(module+ test
  (require rackunit)
  ; correctness and timing tests
  (check-match (time (bernoulli_0..n bernoulli.1 60))
               (list 1/1 (app abs 1/2) 1/6 -1/30 1/42 -1/30 _ ...))
  (check-match (time (bernoulli_0..n bernoulli.2 60))
               (list 1/1 (app abs 1/2) 1/6 -1/30 1/42 -1/30 _ ...))
  (check-match (time (bernoulli_0..n bernoulli.3 60))
               (list 1/1 (app abs 1/2) 1/6 -1/30 1/42 -1/30 _ ...))
  ; timing only ...
  (void (time (bernoulli_0..n bernoulli.3 100))))
