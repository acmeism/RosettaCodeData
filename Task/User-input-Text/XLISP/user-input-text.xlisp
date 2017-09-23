(display "Enter a string: ")
(define s (read-line))
(display "Yes, ")
(write s)
(display " is a string.") ;; no need to verify, because READ-LINE has to return a string
(newline)
(display "Now enter the integer 75000: ")
(define n (read))
(display
    (cond
        ((not (integerp n))
            "That's not even an integer." )
        ((/= n 75000)
            "That is not the integer 75000." )
        (t
            "Yes, that is the integer 75000." ) ) )
