(pipe
   (for X 20
      (for Y (range X 20)
         (for Z (range Y 20)
            (when (= (+ (* X X) (* Y Y)) (* Z Z))
               (pr (list X Y Z)) ) ) ) )
   (while (rd)
      (println @) ) )
