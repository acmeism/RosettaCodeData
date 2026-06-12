#lang typed/racket
(require math/number-theory)

(: montgomery-reduce-fn
   (-> Positive-Integer Natural [#:m-dash Natural]
       (Nonnegative-Integer Natural -> Integer)))

(: ith-digit (Integer Nonnegative-Integer Natural -> Nonnegative-Integer))
(define (ith-digit a i b)
  (modulo (quotient a (expt b i)) b))

(: m-dash (Integer Integer -> Natural))
(define (m-dash m b) ; for if you want to precompute it yourself
  (modular-inverse (- m) b))

(define ((montgomery-reduce-fn m b #:m-dash (m′ (m-dash m b))) T n)
  (define A
    (for/fold : Nonnegative-Integer
      ((A : Nonnegative-Integer T))
      ((i : Nonnegative-Integer (in-range n)))
      (let* ((a_i (ith-digit A i b))
             (u_i (modulo (* a_i m′) b)))
        (+ A (* u_i m (expt b i))))))
  (define A/b^n (quotient A (expt b n)))
  (if (>= A/b^n m)
      (- A/b^n m)
      A/b^n))

; ---------------------------------------------------------------------------------------------------
(module+ test
  (require typed/rackunit)

  (check-equal? (ith-digit 1234 0 10) 4)
  (check-equal? (ith-digit 1234 3 10) 1)

  ;; e.g. ripped off from {{trans|Go}}
  (let ((b  2)
        (n  100)
        (r  1267650600228229401496703205376)
        (m  750791094644726559640638407699)
        (T1 323165824550862327179367294465482435542970161392400401329100)
        (T2 308607334419945011411837686695175944083084270671482464168730)
        (R1 440160025148131680164261562101)
        (R2 435362628198191204145287283255)
        (x1 540019781128412936473322405310)
        (x2 515692107665463680305819378593))
    (define mr (montgomery-reduce-fn m b))
    (check-equal? (mr R1 n) x1)
    (check-equal? (mr R2 n) x2)))
