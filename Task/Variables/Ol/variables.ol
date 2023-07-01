; Declare the symbol 'var1' and associate number 123 with it.
(define var1 123)
(print var1)
; ==> 123

; Reassociate number 321 with var1.
(define var1 321)
(print var1)

; Create function that prints value of var1 ...
(define (show)
   (print var1))
; ... and eassociate number 42 with var1.
(define var1 42)

(print var1)
; ==> 42
; var1 prints as 42, but...
(show)
; ==> 321
; ... function 'show' still print old associated value
