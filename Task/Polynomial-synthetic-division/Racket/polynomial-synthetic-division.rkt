#lang racket/base
(require racket/list)
;; dividend and divisor are both polynomials, which are here simply lists of coefficients.
;; Eg: x^2 + 3x + 5 will be represented as (list 1 3 5)
(define (extended-synthetic-division dividend divisor)
  (define out (list->vector dividend)) ; Copy the dividend
  ;; for general polynomial division (when polynomials are non-monic), we need to normalize by
  ;; dividing the coefficient with the divisor's first coefficient
  (define normaliser (car divisor))
  (define divisor-length (length divisor)) ; } we use these often enough
  (define out-length (vector-length out))  ; }

  (for ((i (in-range 0 (- out-length divisor-length -1))))
    (vector-set! out i (quotient (vector-ref out i) normaliser))
    (define coef (vector-ref out i))
    (unless (zero? coef) ; useless to multiply if coef is 0
      (for ((i+j (in-range (+ i 1)                ; in synthetic division, we always skip the first
                           (+ i divisor-length))) ; coefficient of the divisior, because it's
            (divisor_j (in-list (cdr divisor))))  ;  only used to normalize the dividend coefficients
        (vector-set! out i+j (+ (vector-ref out i+j) (* coef divisor_j -1))))))
  ;; The resulting out contains both the quotient and the remainder, the remainder being the size of
  ;; the divisor (the remainder has necessarily the same degree as the divisor since it's what we
  ;; couldn't divide from the dividend), so we compute the index where this separation is, and return
  ;; the quotient and remainder.

  ;; return quotient, remainder (conveniently like quotient/remainder)
  (split-at (vector->list out) (- out-length (sub1 divisor-length))))

(module+ main
  (displayln "POLYNOMIAL SYNTHETIC DIVISION")
  (define N '(1 -12 0 -42))
  (define D '(1 -3))
  (define-values (Q R) (extended-synthetic-division N D))
  (printf "~a / ~a = ~a remainder ~a~%" N D Q R))
