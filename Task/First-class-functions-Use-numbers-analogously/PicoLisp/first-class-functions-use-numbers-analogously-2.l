(load "@lib/math.l")

(de compose (F G)
   (curry (F G) (X)
      (F (G X)) ) )

(de cube (X)
   (pow X 3.0) )

(de cubeRoot (X)
   (pow X 0.3333333) )

(mapc
   '((Fun Inv)
      (prinl (format ((compose Inv Fun) 0.5) *Scl)) )
   '(sin  cos  cube)
   '(asin acos cubeRoot) )
