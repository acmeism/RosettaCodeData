(de guessTheNumber ()
   (use (Low High Guess)
      (until
         (and
            (prin "Enter low limit : ")
            (setq Low (read))
            (prin "Enter high limit: ")
            (setq High (read))
            (> High Low) ) )
      (seed (time))
      (let Number (rand Low High)
         (loop
            (prin "Guess what number I have: ")
            (T (= Number (setq Guess (read)))
               (prinl "You got it!") )
            (prinl
               "Your guess is too "
               (if (> Number Guess) "low" "high")
               "." ) ) ) ) )
