(be amb (@E @Lst)
   (lst @E @Lst) )

(be joins (@Left @Right)
   (^ @T (last (chop (-> @Left))))
   (^ @R (car (chop (-> @Right))))
   (or
      ((equal @T @R))
      ((amb @ NIL)) ) )  # Explicitly using amb fail as required

(be ambExample ((@Word1 @Word2 @Word3 @Word4))
  (amb @Word1 ("the" "that" "a"))
  (amb @Word2 ("frog" "elephant" "thing"))
  (amb @Word3 ("walked" "treaded" "grows"))
  (amb @Word4 ("slowly" "quickly"))
  (joins @Word1 @Word2)
  (joins @Word2 @Word3)
  (joins @Word3 @Word4) )
