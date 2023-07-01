(import (lib math))

(print
   ; sequence for 1 .. 22
   (map (lambda (n)
         (+ n (floor (+ 1/2 (exact (sqrt n))))))
      (iota 22 1)))
; ==> (2 3 5 6 7 8 10 11 12 13 14 15 17 18 19 20 21 22 23 24 26 27)

(print
   ; filter out non squares
   (filter
      (lambda (x)
         (let ((s (floor (exact (sqrt x)))))
            (= (* s s) x)))
      (map (lambda (n)
            (+ n (floor (+ 1/2 (exact (sqrt n))))))
         (iota 1000000 1))))
; ==> ()
