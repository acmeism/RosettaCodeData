(scl 20)

(de fpsOne (N)
   (if (=0 N) 1.0 0) )

(de fpsInverse (N X)
   (last
      (make
         (let Res1 (- (link (*/ 1.0 1.0 (X 0))))
            (for I N
               (link
                  (*/
                     (sum '((Res J) (*/ (X J) Res 1.0))
                        (made)
                        (range I 1) )
                     Res1
                     1.0 ) ) ) ) ) ) )

(de fpsAdd (N X Y)
   (+ (X N) (Y N)) )

(de fpsSub (N X Y)
   (- (X N) (Y N)) )

(de fpsMul (N X Y)
   (sum
      '((I)
         (*/ (X I) (Y (- N I)) 1.0) )
      (range 0 N) ) )

(de fpsDiv (N X Y)
   (sum
      '((I)
         (*/ (X I) (fpsInverse (- N I) Y) 1.0) )
      (range 0 N) ) )

(de fpsDifferentiate (N)
   (curry (X) (N)
      (* (X (inc N)) N) ) )

(de fpsIntegrate (X)
   (curry (X) (N)
      (or
         (=0 N)
         (*/ (X (dec N)) N) ) ) )

(lazy fpsSin (N)
   ((fpsIntegrate fpsCos) N) )

(lazy fpsCos (N)
   (fpsSub N fpsOne (fpsIntegrate fpsSin)) )

(lazy fpsTan (N)
   (fpsDiv N fpsSin fpsCos) )

(lazy fpsExp (N)
   (if (=0 N)
      1.0
      ((fpsIntegrate fpsExp) N) ) )
