; integer.lsp
; oofoe 2012-01-17

(define (aski msg) (print msg) (int (read-line)))
(setq x (aski "Please type in an integer and press [enter]: "))
(setq y (aski "Please type in another integer             : "))

; Note that +, -, *, / and % are all integer operations.
(println)
(println "Sum: " (+ x y))
(println "Difference: " (- x y))
(println "Product: " (* x y))
(println "Integer quotient (rounds to 0): " (/ x y))
(println "Remainder: " (setq r (% x y)))

(println "Remainder sign matches: "
	 (cond ((= (sgn r) (sgn x) (sgn y)) "both")
	       ((= (sgn r) (sgn x))         "first")
	       ((= (sgn r) (sgn y))         "second")))
	
(println)
(println "Exponentiation: " (pow x y))

(exit) ; NewLisp normally goes to listener after running script.
