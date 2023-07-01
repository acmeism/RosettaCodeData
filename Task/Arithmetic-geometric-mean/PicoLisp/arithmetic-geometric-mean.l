(scl 80)

(de agm (A G)
   (do 7
      (prog1 (/ (+ A G) 2)
         (setq G (sqrt A G)  A @) ) ) )

(round
   (agm 1.0 (*/ 1.0 1.0 (sqrt 2.0 1.0)))
   70 )
