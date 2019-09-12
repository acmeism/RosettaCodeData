(define (sum n base)
   (if (zero? n)
      n
      (+ (mod n base) (sum (div n base) base))))

(print (sum 1 10))
; ==> 1

(print (sum 1234 10))
; ==> 10

(print (sum #xfe 16))
; ==> 29

(print (sum #xf0e 16))
; ==> 29
