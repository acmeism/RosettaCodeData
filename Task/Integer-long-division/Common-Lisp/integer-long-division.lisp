(defun $/ (a b)
 "Divide a/b with infinite precision printing each digit as it is calculated and return the period length"
; ($/ 1 17) => 588235294117647 ; 16
  (assert (and (integerp a) (integerp b) (not (zerop b))))
  (do* (c
       (i0 (1+ (max (factor-multiplicity b 2) (factor-multiplicity b 5)))) ; the position which marks the beginning of the period
       (r a (* 10 r)) ; remainder
       (i 0 (1+ i)) ; iterations counter
       (rem (if (= i i0) r -1) (if (= i i0) r rem)) ) ; the first remainder against which to check for repeating remainders
      ((and (= r rem) (not (= i i0))) (- i i0))
    (multiple-value-setq (c r) (floor r b))
    (princ c) ))


(defun factor-multiplicity (n factor)
"Return how many times the factor is contained in n"
; (factor-multiplicity 12 2) => 2
	(do* ((i 0 (1+ i))
	      (n (/ n factor) (/ n factor)) )
             ((not (integerp n)) i)
	    () ))

