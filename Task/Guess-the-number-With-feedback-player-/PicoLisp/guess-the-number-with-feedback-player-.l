(de guessTheNumber (Min Max)
   (prinl "Think of a number between " Min " and " Max ".")
   (prinl "On every guess of mine you should state whether my guess was")
   (prinl "too high, too low, or equal to your number by typing 'h', 'l', Or '='")
   (use Guess
      (loop
         (NIL (> Max Min)
            (prinl "I think somthing is strange here...") )
         (prin
            "My guess is "
            (setq Guess (+ Min (/ (- Max Min) 2)))
            ",is this correct? " )
         (flush)
         (NIL
            (case (uppc (car (line)))
               ("H" (setq Max Guess))
               ("L" (setq Min Guess))
               ("=" (nil (prinl "I did it!")))
               (T (prinl "I do not understand that...")) ) ) ) ) )
