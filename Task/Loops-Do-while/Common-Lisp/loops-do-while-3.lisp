(do* ((a 0)		     ; Initialize to 0
      (b (incf a) (incf b))) ; Set first increment and increment on every loop
     ((zerop (mod b 6)) (print b)) ; Break condition and print last value `6' (right?)
  (print b))			   ; On every loop print value
