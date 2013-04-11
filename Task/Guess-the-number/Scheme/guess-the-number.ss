(define number (random 11))
(display "Pick a number from 1 through 10.\n> ")
(do ((guess (read) (read))) ((= guess number)) (display "Guess again.\n> "))
(display "Well guessed!\n")
