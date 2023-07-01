(define (to-celsius k)
    (- k 273.15)
)

(define (to-fahrenheit k)
    (- (* k 1.8) 459.67)
)

(define (to-rankine k)
    (* k 1.8)
)

(define (kelvinConversion k)
    (if (number? k)
        (println k " kelvin is equivalent to:\n"
            (to-celsius k) " celsius\n"
            (to-fahrenheit k) " fahrenheit\n"
            (to-rankine k) " rankine")
        (println "Please enter a number only, with no º or letter. ")
    )
)
