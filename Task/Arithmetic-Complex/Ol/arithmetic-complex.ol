(define A 0+1i) ; manually entered numbers
(define B 1+0i)

(print (+ A B))
; <== 1+i

(print (- A B))
; <== -1+i

(print (* A B))
; <== 0+i

(print (/ A B))
; <== 0+i


(define C (complex 2/7 -3)) ; functional way

(print "real part of " C " is " (car C))
; <== real part of 2/7-3i is 2/7

(print "imaginary part of " C " is " (cdr C))
; <== imaginary part of 2/7-3i is -3
