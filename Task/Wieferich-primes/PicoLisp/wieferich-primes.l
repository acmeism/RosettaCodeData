(de **Mod (X Y N)
   (let M 1
      (loop
         (when (bit? 1 Y)
            (setq M (% (* M X) N)) )
         (T (=0 (setq Y (>> 1 Y)))
            M )
         (setq X (% (* X X) N)) ) ) )
(let (D 2  L (1 2 2 . (4 2 4 2 4 6 2 6 .)))
   (until (> D 5000)
      (and
         (=1 (**Mod 2 (dec D) (* D D)))
         (println D) )
      (inc 'D (++ L)) ) )
