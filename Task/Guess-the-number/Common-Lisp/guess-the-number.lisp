(defun guess-the-number (max)
  (format t "Try to guess a number from 1 to ~a!~%Guess? " max)
  (loop with num = (1+ (random max))
        for guess = (read)
        as num-guesses from 1
        until (and (numberp guess) (= guess num))
        do (format t "Your guess was wrong.  Try again.~%Guess? ")
           (force-output)
        finally (format t "Well guessed! You took ~a ~:*~[~;try~:;tries~].~%" num-guesses)))
