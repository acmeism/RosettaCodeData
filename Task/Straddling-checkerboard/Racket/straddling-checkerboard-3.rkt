(define (test-straddling message board)
  (let* ([encoded (straddle message board)]
         [decoded (unstraddle encoded board)])
    (displayln board)
    (displayln message)
    (displayln encoded)
    (displayln decoded)))

(test-straddling "One night-it was on the twentieth of March, 1888-I was returning"
                 (straddling "HOL MES RT"
                             "ABCDFGIJKN"
                             "PQUVWXYZ./"))
(newline)
(test-straddling "One night-it was on the twentieth of March, 1888-I was returning"
                 (straddling "ET AON RIS"
                             "BCDFGHJKLM"
                             "PQ/UVWXYZ."))
