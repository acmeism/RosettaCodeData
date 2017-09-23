; let's input the numbers list
(define x (read))
; <== (1 2 3 4 5)

(print x)
; ==> '(1 2 3 4 5)

(print (apply max x))
; ==> 5

(print (fold max (car x) x))
; ==> 5

(print (fold (lambda (a b)
   (if (less? a b) b a))
   (car x) x))
; ==> 5
