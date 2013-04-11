(de pythag (N)
   (job '((X . 1) (Y . 1) (Z . 0))
      (loop
         (when (> (inc 'Z) N)
            (when (> (inc 'Y) N)
               (setq Y (inc 'X)) )
            (setq Z Y) )
         (T (> X N))
         (T (= (+ (* X X) (* Y Y)) (* Z Z))
            (list X Y Z) ) ) ) )

(while (pythag 20)
   (println @) )
