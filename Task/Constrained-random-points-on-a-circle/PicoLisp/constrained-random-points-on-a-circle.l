(let Area (make (do 31 (link (need 31 " "))))
   (use (X Y)
      (do 100
         (until
            (>=
               15
               (sqrt
                  (+
                     (* (setq X (rand -15 15)) X)
                     (* (setq Y (rand -15 15)) Y) ) )
               10 ) )
         (set (nth Area (+ 16 X) (+ 16 Y)) "#") ) )
   (mapc prinl Area) )
