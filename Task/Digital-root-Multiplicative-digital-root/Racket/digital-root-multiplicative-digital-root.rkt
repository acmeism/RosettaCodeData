#lang racket
(define (digital-product n)
  (define (inr-d-p m rv)
    (cond
      [(zero? m) rv]
      [else (define-values (q r) (quotient/remainder m 10))
            (if (zero? r) 0 (inr-d-p q (* rv r)))])) ; lazy on zero
  (inr-d-p n 1))

(define (mdr/mp n)
  (define (inr-mdr/mp m i)
    (if (< m 10) (values m i) (inr-mdr/mp (digital-product m) (add1 i))))
  (inr-mdr/mp n 0))

(printf "Number\tMDR\tmp~%======\t===\t==~%")
(for ((n (in-list '(123321 7739 893 899998))))
  (define-values (mdr mp) (mdr/mp n))
  (printf "~a\t~a\t~a~%" n mdr mp))

(printf "~%MDR\t[n0..n4]~%===\t========~%")
(for ((MDR (in-range 10)))
  (define (has-mdr? n) (define-values (mdr mp) (mdr/mp n)) (= mdr MDR))
  (printf "~a\t~a~%" MDR (for/list ((_ 5) (n (sequence-filter has-mdr? (in-naturals)))) n)))
