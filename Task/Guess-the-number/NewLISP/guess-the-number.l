; guess-number.lsp
; oofoe 2012-01-19
; http://rosettacode.org/wiki/Guess_the_number

(seed (time-of-day)) ; Initialize random number generator from clock.
(setq number (+ 1 (rand 10)))

(println "I'm thinking of a number between 1 and 10. Can you guess it?")
(print   "Type in your guess and hit [enter]: ")
(while (!= number (int (read-line))) (print "Nope! Try again: "))
(println "Well guessed! Congratulations!")

(exit)
