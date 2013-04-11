(de guessTheNumber ()
   (let Number (rand 1 9)
      (loop
         (prin "Guess the number: ")
         (T (= Number (read))
            (prinl "Well guessed!") )
         (prinl "Sorry, this was wrong") ) ) )
