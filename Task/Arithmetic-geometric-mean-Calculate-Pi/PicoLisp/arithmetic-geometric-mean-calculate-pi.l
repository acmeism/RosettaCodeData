(scl 40)

(de pi ()
   (let
      (A 1.0  N 1.0  Z 0.25
         G (/ (* 1.0 1.0) (sqrt 2.0 1.0)) )
      (use (X1 X2 V)
         (do 18
            (setq
               X1 (/ (* (+ A G) 0.5) 1.0)
               X2 (sqrt (* A G))
               V (- X1 A)
               Z (- Z (/ (* (/ (* V V) 1.0) N) 1.0))
               N (+ N N)
               A X1
               G X2 ) ) )
      (round (/ (* A A) Z) 40)) )

(println (pi))

(bye)
