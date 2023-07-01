#lang racket
(define (fract-part f)
  (- f (truncate f)))

(define ln10 (log 10))
(define ln2/ln10 (/ (log 2) ln10))

(define (inexact-p-test L)
  (let ((digit-shift (let loop ((L (quotient L 10)) (shift 1))
                       (if (zero? L) shift (loop (quotient L 10) (* 10 shift))))))
    (λ (p) (= L (truncate (* digit-shift (exp (* ln10 (fract-part (* p ln2/ln10))))))))))

(define (p L n)
  (let ((test? (inexact-p-test L)))
    (let loop ((j 1) (n (sub1 n)))
      (cond [(not (test? j)) (loop (add1 j) n)]
            [(zero? n) j]
            [else (loop (add1 j) (sub1 n))]))))

(module+ main
  (define (report-p L n)
    (time (printf "p(~a, ~a) = ~a~%" L n (p L n))))

  (report-p 12 1)
  (report-p 12 2)
  (report-p 123 45)
  (report-p 123 12345)
  (report-p 123 678910))
