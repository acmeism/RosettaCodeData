(let (X 77444  Y -12  Z 0)
   (println X Y Z)
   (mapc set '(X Y Z) (sort (list X Y Z)))
   (println X Y Z) )
