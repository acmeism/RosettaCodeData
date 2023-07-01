(load "@lib/math.l")

(de multiplier (N1 N2)
   (curry (N1 N2) (X)
      (*/ N1 N2 X `(* 1.0 1.0)) ) )

(let (X 2.0  Xi 0.5  Y 4.0  Yi 0.25  Z (+ X Y)  Zi (*/ 1.0 1.0 Z))
   (mapc
      '((Num Inv)
         (prinl (format ((multiplier Inv Num) 0.5) *Scl)) )
      (list X Y Z)
      (list Xi Yi Zi) ) )
