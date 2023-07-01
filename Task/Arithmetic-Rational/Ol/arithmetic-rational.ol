(define x 3/7)
(define y 9/11)
(define z -2/5)

; demonstrate builtin functions:

(print "(abs " z ") = " (abs z))
(print "- " z " = " (- z))
(print x " + " y " = " (+ x y))
(print x " - " y " = " (- x y))
(print x " * " y " = " (* x y))
(print x " / " y " = " (/ x y))
(print x " < " y " = " (< x y))
(print x " > " y " = " (> x y))

; introduce new functions:

(define (+:= x) (+ x 1))
(define (-:= x) (- x 1))

(print "+:= " z " = " (+:= z))
(print "-:= " z " = " (-:= z))

; finally, find all perfect numbers less than 2^15:

(lfor-each (lambda (candidate)
      (let ((sum (lfold (lambda (sum factor)
                     (if (= 0 (modulo candidate factor))
                        (+ sum (/ 1 factor) (/ factor candidate))
                        sum))
                  (/ 1 candidate)
                  (liota 2 1 (+ (isqrt candidate) 1)))))
         (if (= 1 (denominator sum))
            (print candidate (if (eq? sum 1) ", perfect" "")))))
   (liota 2 1 (expt 2 15)))
