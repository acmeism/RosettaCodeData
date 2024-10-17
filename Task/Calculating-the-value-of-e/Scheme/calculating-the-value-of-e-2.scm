; Use series to compute approximation to exp(z) (using N terms of series).
;          n-1
; exp(z) ~ SUM ( z^k / k! )
;          k=0

(define exp
  (lambda (z n)
    (do ((k 0 (1+ k))
         (sum 0 (+ sum (/ (expt z k) (fact k)))))
        ((>= k n) sum))))

; Procedure to compute factorial.

(define fact
  (lambda (n)
    (if (<= n 0)
      1
      (* n (fact (1- n))))))
