#lang typed/racket

(: fract-part (-> Float Float))
(: ln10 Positive-Float)
(: ln2/ln10 Positive-Float)
(: p (-> Positive-Index Positive-Index Positive-Integer))

(define (fract-part f)
  (- f (truncate f)))

(define ln10 (cast (log 10) Positive-Float))
(define ln2/ln10 (cast (/ (log 2) ln10) Positive-Float))

(define (inexact-p-test [L : Positive-Index])
  (let ((digit-shift : Nonnegative-Float
                     (let loop ((L (quotient L 10)) (shift : Nonnegative-Float 1.))
                       (if (zero? L) shift (loop (quotient L 10) (* 10. shift)))))
        (l (exact->inexact L)))
    (: f (-> Nonnegative-Float Boolean))
    (define (f p) (= l (truncate (* digit-shift (exp (* ln10 (fract-part (* p ln2/ln10))))))))
    f))

(define (p L n)
  (let ((test? (inexact-p-test L)))
    (let loop : Positive-Integer ((j : Positive-Float 1.) (n : Index (sub1 n)))
      (cond [(not (test? j)) (loop (add1 j) n)]
            [(zero? n) (assert (exact-round j) positive?)]
            [else (loop (add1 j) (sub1 n))]))))

(module+ main
  (: report-p (-> Positive-Index Positive-Index Void))
  (define (report-p L n)
    (time (printf "p(~a, ~a) = ~a~%" L n (p L n))))

  (report-p 12 1)
  (report-p 12 2)
  (report-p 123 45)
  (report-p 123 12345)
  (report-p 123 678910))
