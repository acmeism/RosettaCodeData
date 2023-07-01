; guess-number-feedback.lsp
; oofoe 2012-01-19
; http://rosettacode.org/wiki/Guess_the_number/With_feedback

(seed (time-of-day)) ; Initialize random number generator from clock.
(setq low  -5
      high 62
      number (+ low (rand (- high low)))
      found nil
)

(print "I'm thinking of a number between " low " and " high ".")

(while (not found)
  (print " What's your guess? ")
  (setq guess (int (read-line) 'bad))
  (print (cond ((= 'bad guess) "That's not a number! Try again!")
               ((or (< guess low) (> guess high))
                (string "My number is between " low
                        " and " high ". Try again!"))
               ((< number guess) "Try a little lower...")
               ((> number guess) "Maybe a bit higher...")
               ((= number guess) (setq found true) "Exactly right!")))
  )

(println "\nWell guessed! Congratulations!")

(exit)
