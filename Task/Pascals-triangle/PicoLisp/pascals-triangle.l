(de pascalTriangle (N)
   (for I N
      (space (* 2 (- N I)))
      (let C 1
         (for K I
            (prin (align 3 C) " ")
            (setq C (*/ C (- I K) K)) ) )
      (prinl) ) )
