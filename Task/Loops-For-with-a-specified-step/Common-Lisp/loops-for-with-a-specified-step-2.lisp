(do ((n 0 (incf n (+ (random 3) 2))))	; Initialize to 0 and set random step-value 2, 3 or 4
    ((> n 20))				; Break condition
  (print n))				; On every loop print value
