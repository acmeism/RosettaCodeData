(defun guessing-game (a b)
    ; minimum and maximum, to be supplied by the user
    (defun prompt ()
        (display "What is your guess? ")
        (define guess (read))
        (if (eq guess n) ; EQ, unlike =, won't blow up
                         ; if GUESS isn't a number
            (display "Well guessed!")
            (begin
                (display
                    (cond
                        ((not (integer? guess)) "Come on, that isn't even an integer")
                        ((or (< guess a) (> guess b)) "Now you   k n o w   it won't be that")
                        ((< guess n) "Too low")
                        ((> guess n) "Too high")))
                (display "! Try again...")
                (newline)
                (prompt))))
    (define n (+ (random (- (+ b 1) a)) a))
    (display "I have thought of an integer between ")
    (display a)
    (display " and ")
    (display b)
    (display ". Try to guess it!")
    (newline)
    (prompt))
