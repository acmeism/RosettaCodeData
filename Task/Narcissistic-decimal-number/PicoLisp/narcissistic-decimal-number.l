(let (C 25 N 0 L 1)
   (loop
      (when
         (=
            N
            (sum ** (mapcar format (chop N)) (need L L)) )
         (println N)
         (dec 'C) )
      (inc 'N)
      (setq L (length N))
      (T (=0 C) 'done) ) )

(bye)
