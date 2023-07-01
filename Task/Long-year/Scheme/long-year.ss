(define (dec31wd year)
    (remainder (apply + (map (lambda (d) (quotient year d)) '(1 4 -100 400))) 7))

(define (long? year) (or (= 4 (dec31wd year)) (= 3 (dec31wd (- year 1)))))

(display "Long years between 1800 and 2100:") (newline)
(display (filter long? (iota 300 1800)))
