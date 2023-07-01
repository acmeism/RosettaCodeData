(scl 6)

(de cubicBezier (Img N X1 Y1 X2 Y2 X3 Y3 X4 Y4)
   (let (R (* N N N)  X X1  Y Y1  DX 0  DY 0)
      (for I N
         (let
            (J (- N I)
               A (*/ 1.0 J J J R)
               B (*/ 3.0 I J J R)
               C (*/ 3.0 I I J R)
               D (*/ 1.0 I I I R) )
            (brez Img
               X
               Y
               (setq DX
                  (-
                     (+ (*/ A X1 1.0) (*/ B X2 1.0) (*/ C X3 1.0) (*/ D X4 1.0))
                     X ) )
               (setq DY
                  (-
                     (+ (*/ A Y1 1.0) (*/ B Y2 1.0) (*/ C Y3 1.0) (*/ D Y4 1.0))
                     Y ) ) )
            (inc 'X DX)
            (inc 'Y DY) ) ) ) )
