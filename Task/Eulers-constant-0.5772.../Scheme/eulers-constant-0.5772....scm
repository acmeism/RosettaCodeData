; Procedure to compute factorial.
(define fact
  (lambda (n)
    (if (<= n 0)
      1
      (* n (fact (1- n))))))

; Compute Euler's gamma constant as the difference of log(n) from a sum.
; See section 2.3 of <http://numbers.computation.free.fr/Constants/Gamma/gamma.html>.
(define gamma
  (lambda (n)
    (let ((sum 0))
      (do ((k 1 (1+ k)))
          ((> k (* 3.5911 n)) (- sum (log n)))
        (set! sum (+ sum (/ (* (expt -1 (1- k)) (expt n k)) (* k (fact k)))))))))

; Show Euler's gamma constant computed at log(100).
(printf "Euler's gamma constant: ~a~%" (gamma 100))
