(let Doors (need 100)
   (for I 100
      (for (D (nth Doors I)  D  (cdr (nth D I)))
         (set D (not (car D))) ) )
   (println Doors) )
