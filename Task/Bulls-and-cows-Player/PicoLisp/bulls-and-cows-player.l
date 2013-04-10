(load "@lib/simul.l")

(de bullsAndCows ()
   (let Choices (shuffle (mapcan permute (subsets 4 (range 1 9))))
      (use (Guess Bulls Cows)
         (loop
            (prinl "Guessing " (setq Guess (pop 'Choices)))
            (prin "How many bulls and cows? ")
            (setq Bulls (read)  Cows (read))
            (setq Choices
               (filter
                  '((C)
                     (let B (cnt = Guess C)
                        (and
                           (= Bulls B)
                           (= Cows (- (length (sect Guess C)) B)) ) ) )
                  Choices ) )
            (NIL Choices "No matching solution")
            (NIL (cdr Choices) (pack "The answer is " (car Choices))) ) ) ) )
