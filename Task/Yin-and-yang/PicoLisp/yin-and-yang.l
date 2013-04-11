(de circle (X Y C R)
   (>=
      (* R R)
      (+
         (* (setq X (/ X 2)) X)
         (* (dec 'Y C) Y) ) ) )

(de yinYang (R)
   (for Y (range (- R) R)
      (for X (range (- 0 R R) (+ R R))
         (prin
            (cond
               ((circle X Y (- (/ R 2)) (/ R 6))
                  "#" )
               ((circle X Y (/ R 2) (/ R 6))
                  "." )
               ((circle X Y (- (/ R 2)) (/ R 2))
                  "." )
               ((circle X Y (/ R 2) (/ R 2))
                  "#" )
               ((circle X Y 0 R)
                  (if (lt0 X) "." "#") )
               (T " ") ) ) )
      (prinl) ) )
