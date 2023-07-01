(de factors (N)
   (let C 1
      (when (>= N 2)
         (inc 'C)
         (for (I 2 (>= (/ N 2) I) (inc I))
            (and (=0 (% N I)) (inc 'C)) ) )
      C ) )
(de anti (X)
   (let (M 0  I 0  N 0)
      (make
         (while (> X I)
            (inc 'N)
            (let R (factors N)
               (when (> R M)
                  (link N)
                  (setq M R)
                  (inc 'I) ) ) ) ) ) )
(println (anti 20))