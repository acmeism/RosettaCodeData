(import (scheme base)
        (scheme read)
        (scheme write))

(define (kelvin->celsius k)
  (- k 273.15))

(define (kelvin->fahrenheit k)
  (- (* k 1.8) 459.67))

(define (kelvin->rankine k)
  (* k 1.8))

;; Run the program
(let ((k (begin (display "Kelvin    : ") (flush-output-port) (read))))
  (when (number? k)
    (display "Celsius   : ") (display (kelvin->celsius k)) (newline)
    (display "Fahrenheit: ") (display (kelvin->fahrenheit k)) (newline)
    (display "Rankine   : ") (display (kelvin->rankine k)) (newline)))
